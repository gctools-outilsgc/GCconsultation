class Test::Legislation::ProcessesController < Test::Legislation::BaseController
  include Translatable

  has_filters %w{open next past all}, only: :index

  load_and_authorize_resource :process, class: "Legislation::Process"

  def index
    @processes = ::Legislation::Process.send(@current_filter).order('id DESC').page(params[:page])
  end

  def create
    if @process.save
      link = legislation_process_path(@process).html_safe
      notice = t('test.legislation.processes.create.notice', link: link)
      redirect_to edit_test_legislation_process_path(@process), notice: notice
    else
      flash.now[:error] = t('test.legislation.processes.create.error')
      render :new
    end
  end

  def update
    if @process.update(process_params)
      set_tag_list

      link = legislation_process_path(@process).html_safe
      redirect_to :back, notice: t('test.legislation.processes.update.notice', link: link)
    else
      flash.now[:error] = t('test.legislation.processes.update.error')
      render :edit
    end
  end

  def destroy
    @process.destroy
    notice = t('test.legislation.processes.destroy.notice')
    redirect_to test_legislation_processes_path, notice: notice
  end

  private

    def process_params
      params.require(:legislation_process).permit(allowed_params)
    end

    def allowed_params
      [
        :start_date,
        :end_date,
        :debate_start_date,
        :debate_end_date,
        :draft_start_date,
        :draft_end_date,
        :draft_publication_date,
        :allegations_start_date,
        :allegations_end_date,
        :proposals_phase_start_date,
        :proposals_phase_end_date,
        :result_publication_date,
        :debate_phase_enabled,
        :draft_phase_enabled,
        :allegations_phase_enabled,
        :proposals_phase_enabled,
        :draft_publication_enabled,
        :result_publication_enabled,
        :published,
        :custom_list,
        translation_params(::Legislation::Process),
        documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy]
      ]
    end

    def set_tag_list
      @process.set_tag_list_on(:customs, process_params[:custom_list])
      @process.save
    end

    def resource
      @process || ::Legislation::Process.find(params[:id])
    end
end
