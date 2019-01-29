class Test::Legislation::QuestionsController < Test::Legislation::BaseController
  include Translatable

  load_and_authorize_resource :process, class: "Legislation::Process"
  load_and_authorize_resource :question, class: "Legislation::Question", through: :process

  def index
    @questions = @process.questions
  end

  def new
  end

  def create
    @question.author = current_user
    if @question.save
      notice = t('test.legislation.questions.create.notice', link: question_path)
      redirect_to test_legislation_process_questions_path, notice: notice
    else
      flash.now[:error] = t('test.legislation.questions.create.error')
      render :new
    end
  end

  def update
    if @question.update(question_params)
      notice = t('test.legislation.questions.update.notice', link: question_path)
      redirect_to edit_test_legislation_process_question_path(@process, @question), notice: notice
    else
      flash.now[:error] = t('test.legislation.questions.update.error')
      render :edit
    end
  end

  def destroy
    @question.destroy
    notice = t('test.legislation.questions.destroy.notice')
    redirect_to test_legislation_process_questions_path, notice: notice
  end

  private

    def question_path
      legislation_process_question_path(@process, @question).html_safe
    end

    def question_params
      params.require(:legislation_question).permit(
        translation_params(::Legislation::Question),
        question_options_attributes: [:id, :_destroy,
                                      translation_params(::Legislation::QuestionOption)]
      )
    end

    def resource
      @question || ::Legislation::Question.find(params[:id])
    end
end
