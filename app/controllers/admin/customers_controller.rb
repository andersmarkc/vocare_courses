module Admin
  class CustomersController < BaseController
    def index
      @customers = Customer.includes(:token).order(created_at: :desc)
    end

    def show
      @customer = Customer.find(params[:id])
      course = Course.find_by(published: true)
      @tracker = Progress::Tracker.new(@customer) if course
      @course = course
      @quiz_attempts = @customer.quiz_attempts.includes(:quiz).order(created_at: :desc)
    end
  end
end
