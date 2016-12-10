class ProjectsController < BaseController
  before_action :add_user_to_notes, only: %i(create update)
  before_action :set_project, only: %i(show update destroy set_status add_team_member remove_team_member)

  def_param_group :project do
    param :project, Hash, required: true do
      param :slug, String, desc: 'Project slug', required: true
    end
  end

  ################# Documentation ##############################################
  api :GET, '/projects', 'Returns all projects for user'
  param_group :project
  example <<-EOS
    [
      {
        id:
        name:
        slug:
        status:
        platform:
        thumb:
        scale:
        unit:
        color_format:
        artboards_count:
        styleguide_id:
        created_at:
        updated_at:
        team: {
          id:
          users: [
            {
              name:
              image:
              email:
            }
          ]
        }
      }
    ]
  EOS
  error code: 401, desc: 'You have no access to this project!'
  error code: 422, desc: 'Please open Draft and create a project!'
  error code: 404, desc: 'Project not found'
  ################# /Documentation #############################################
  def index
    @projects = current_user.projects

    render json: @projects.decorate.to_json, status: :ok
  end

  # GET /projects/project_names
  # List user's projects for Sketch plugin
  def project_names
    @projects = current_user.projects

    render json: @projects.map { |project| { name: project.name, slug: project.slug } }, status: 200
  end

  ################# Documentation ##############################################
  api :GET, '/projects/:id', 'Returns the specified project'
  example <<-EOS
    {
      id:
      name:
      slug:
      status:
      platform:
      thumb:
      scale:
      unit:
      colorFormat:
      artboardsCount:
      slices:
      colors:
      artboards:
      styleguide_id:
      created_at:
      updated_at:
      team: {
        id:
        users: [
          {
            name:
            image:
            email:
          }
        ]
      }
    }
  EOS
  param_group :project
  param :page, Integer, desc: 'Artboards page', required: false
  error code: 401, desc: 'You have no access to this project!'
  error code: 422, desc: 'Please open Draft and create a project!'
  error code: 404, desc: 'Project not found'
  ################# /Documentation #############################################
  def show
    render json: @project.decorate.to_json(page: params[:page])
      .deep_transform_keys { |k| k.to_s.camelize(:lower) }
  end

  ################# Documentation ##############################################
  api :POST, '/projects', 'Returns the created project or the errors'
  example <<-EOS
    {
      id:
      name:
      slug:
      status:
      platform:
      thumb:
      scale:
      unit:
      colorFormat:
      artboardsCount:
      slices:
      colors:
      artboards:
      styleguide_id:
      created_at:
      updated_at:
      team: {
        id:
        users: [
          {
            name:
            image:
            email:
          }
        ]
      }
    }
  EOS
  param :project, Hash, required: true do
    param :name, String, desc: 'Project name', required: true
    param :platform, String, desc: 'Project platform (iOS, Android, Web)', required: true
    param :scale, String, desc: 'Project scale', required: false
    param :colorFormat, String, desc: 'Project color format', required: false
    param :unit, String, desc: 'Project unit (px, pt)', required: true
  end
  error code: 400, desc: 'Bad request, when empty project hash is passed'
  error code: 401, desc: 'You have no access to this project!'
  error code: 404, desc: 'Project not found'
  ################# /Documentation #############################################
  def create
    @project = Project.find_by(slug: project_params[:slug]) if project_params[:slug].present?

    if @project
      # Offload the processing and creation to a BG job
      UpdateProjectJob.perform_later(project_id: @project.id,
                                     project_settings: project_settings.to_h,
                                     project_params: project_params.to_h,
                                     current_user: current_user)
    else
      @project = Project.create(project_params)
      @project.create_activity(action: 'create_project',
                               project_id: @project.id,
                               parameters: { type: 0, what: @project.name },
                               owner: current_user)

      team = Team.create(project_id: @project.id)
      Membership.create(user_id: current_user.id, team_id: team.id)
    end

    render json: @project.errors, status: :unprocessable_entity && return if @project.errors.present?

    # TODO: Return the location of the project sharing link
    render json: @project.decorate.to_json
      .deep_transform_keys { |k| k.to_s.camelize(:lower) }, status: :created
  end

  ################# Documentation ##############################################
  api :PUT, '/projects/:id', 'Returns the updated project'
  example <<-EOS
    {
      id:
      name:
      slug:
      status:
      platform:
      thumb:
      scale:
      unit:
      colorFormat:
      artboardsCount:
      slices:
      colors:
      artboards:
      styleguide_id:
      created_at:
      updated_at:
      team: {
        id:
        users: [
          {
            name:
            image:
            email:
          }
        ]
      }
    }
  EOS
  param_group :project
  error code: 401, desc: 'You have no access to this project!'
  error code: 422, desc: 'Please open Draft and create a project!'
  error code: 404, desc: 'Project not found'
  ################# /Documentation #############################################
  def update
    if @project.update(project_params)
      render json: @project.decorate.to_json.deep_transform_keys { |k| k.to_s.camelize(:lower) }
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  ################# Documentation ##############################################
  api :DELETE, '/projects/:id', 'Does not return anything'
  param_group :project
  error code: 401, desc: 'You have no access to this project!'
  error code: 422, desc: 'Please open Draft and create a project!'
  error code: 404, desc: 'Project not found'
  ################# /Documentation #############################################
  def destroy
    @project.destroy

    render json: {}, status: :ok
  end

  ################# Documentation ##############################################
  api :POST, '/projects/:id/set_status', 'Sets the status for the project'
  example <<-EOS
    [
      {
        id:
        name:
        slug:
        status:
        platform:
        thumb:
        scale:
        unit:
        colorFormat:
        artboardsCount:
        slices:
        colors:
        artboards:
        created_at:
        updated_at:
        team: {
          id:
          users: [
            {
              name:
              image:
              email:
            }
          ]
        }
      }
    ]
  EOS
  param :project, Hash, required: true do
    param :slug, String, desc: 'Project slug', required: true
    param :status, Integer, desc: 'Project new status', required: true
  end
  error code: 401, desc: 'You have no access to this project!'
  error code: 404, desc: 'Artboard not found'
  ################# /Documentation #############################################
  def set_status
    return unless project_params[:status].present?

    if @project.update(status: project_params[:status])
      render json: @project.decorate.to_json
        .deep_transform_keys { |k| k.to_s.camelize(:lower) }
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  ################# Documentation ##############################################
  api :POST, '/projects/:id/add_team_member', 'Add a team member to the project'
  example <<-EOS
    team: {
      id:
      users: [
        {
          name:
          firstname:
          lastname:
          image:
          email:
        }
      ]
    }
    OR
    message: 'User is already a team member of this project!'
  EOS
  param :project, Hash, required: true do
    param :slug, String, desc: 'Project slug', required: true
  end
  param :users, Array, desc: 'Users data to be invited', required: true do
    param :email, String, desc: 'User email', required: true
    param :firstname, String, desc: 'User first name', required: false
    param :lastname, String, desc: 'User last name', required: false
    param :role, Integer, desc: 'User role, 0 is member, 1 is admin', required: false
  end
  error code: 401, desc: 'You have no access to this project!'
  error code: 404, desc: 'Project not found'
  meta message: 'User is already a team member of this project!'
  ################# /Documentation #############################################
  def add_team_member
    params[:project][:users].each do |user_data|
      user = User.find_by(email: user_data['email'])
      unless user
        user = User.invite!({email: user_data['email'], firstname: user_data['firstname'],
                            lastname: user_data['lastname'], role: user_data['role']}, current_user)
      end

      membership = Membership.find_or_initialize_by(user_id: user.id, team_id: @project.team_id)
      membership.save if membership.new_record?
    end
    render json: { team: @project.team.decorate.to_json }, status: :ok
  end

  ################# Documentation ##############################################
  api :POST, '/projects/:id/remove_team_member', 'Remove a team member to the project'
  example <<-EOS
    team: {
      id:
      users: [
        {
          name:
          firstname:
          lastname:
          image:
          email:
        }
      ]
    }
  EOS
  param :project, Hash, required: true do
    param :slug, String, desc: 'Project slug', required: true
  end
  param :email, String, desc: 'User email', required: true
  error code: 401, desc: 'You have no access to this project!'
  error code: 404, desc: 'Project not found'
  error code: 404, desc: 'This user is not found!'
  ################# /Documentation #############################################
  def remove_team_member
    return render json: { errors: ['You are not an admin for this project!'] }, status: :unprocessable_entity if current_user.role != 1

    user = User.find_by(email: params[:project]['email'])
    return render json: { errors: ['This user is not found!'] }, status: :unprocessable_entity unless user

    return render json: { errors: ["You can't remove yourself!"]}, status: :unprocessable_entity if user == current_user

    membership = Membership.find_by(user_id: user.id, team_id: @project.team_id)
    return render json: { errors: ['This user is not a member of this project!'] }, status: 422 unless membership

    membership.destroy
    render json: { team: @project.team.decorate.to_json }, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    return render json: { errors: ['Please open Draft and create a project!'] }, status: 422 if project_params[:slug] == 'empty'

    # TODO: Add team_id
    @project = Project.find_by(slug: project_params[:slug])

    membership = Membership.find_by(user_id: current_user.id, team_id: @project.team_id)
    return render json: { errors: ['You have no access to this project!'] }, status: 401 unless membership

    return render json:  { errors: ['Project not found!'] }, status: 404 unless @project
  end

  def project_settings
    project_params.select { |key| key.to_sym.in? Project::SETTINGS }
  end

  def add_user_to_notes
    project_params
    return unless @project_params[:artboards_attributes].present?

    @project_params[:artboards_attributes].each do |artboard|
      return unless artboard[:notes_attributes].present?

      artboard[:notes_attributes].each do |note|
        note[:user_id] = current_user.id
      end
    end
  end

  # Only allow a trusted parameter 'white list' through.
  def project_params
    @project_params ||=
    params.require(:project).permit(:name,
                                    :slug,
                                    :status,
                                    :platform,
                                    :scale,
                                    :unit,
                                    :color_format,
                                    artboards_attributes: [
                                      :page_name, :page_object_id, :name, :slug, :object_id,
                                      :width, :height, :image_path, :artboard_image, :style,
                                      layers: [
                                        :object_id, :type, :name, :rotation, :radius, :opacity,
                                        :style_name, :font_size, :font_face, :text_align, :letter_spacing,
                                        :line_height, :content, rect: [
                                          :max_x, :max_y, :x, :y, :width, :height
                                        ], css: [], borders: [
                                          :fill_type, :position, :thickness,
                                          gradient: [
                                            :type, from: [:x, :y], to: [:x, :y], color_stops: [
                                              :position,
                                              color: [
                                                :r, :g, :b, :a, :color_hex, :argb_hex, :css_rgba, :ui_color
                                              ]
                                            ]
                                          ],
                                          color: [
                                            :r, :g, :b, :a, :color_hex, :argb_hex, :css_rgba, :ui_color
                                          ]
                                        ],
                                        fills: [
                                          :fill_type, gradient: [
                                            :type, from: [:x, :y], to: [:x, :y],
                                            color_stops: [
                                              :position,
                                              color: [
                                                :r, :g, :b, :a, :color_hex, :argb_hex, :css_rgba, :ui_color
                                              ]
                                            ]
                                          ],
                                          color: [
                                            :r, :g, :b, :a, :color_hex, :argb_hex, :css_rgba, :ui_color
                                          ],
                                        ], shadows: [:type, :offset_x, :offset_y, :blur_radius, :spread, color: [
                                          :r, :g, :b, :a, :color_hex, :argb_hex, :css_rgba, :ui_color
                                          ]], color: [
                                          :r, :g, :b, :a, :color_hex, :argb_hex, :css_rgba, :ui_color
                                          ], exportables_attributes: [
                                            :name, :density, :format, :path
                                          ]
                                      ],
                                      notes_attributes: [
                                        :object_id,
                                        :note,
                                        rect: [
                                          :x, :y, :width, :height
                                        ]
                                      ]
                                    ],
                                    slices: [
                                      :name, :object_id,
                                      rect: [
                                        :x, :y, :width, :height
                                      ],
                                      exportables_attributes: [
                                        :name, :density, :format, :path, :file
                                      ]
                                    ],
                                    colors: [
                                      :name, color: [
                                        :r, :g, :b, :a, :color_hex, :argb_hex, :css_rgba, :ui_color
                                      ]
                                    ]
                                   )
  end
end
