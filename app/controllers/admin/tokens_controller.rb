module Admin
  class TokensController < BaseController
    def index
      @tokens = Token.includes(:customer, :created_by).order(created_at: :desc)
    end

    def show
      @token = Token.includes(:customer).find(params[:id])
    end

    def new
      @token = Token.new
    end

    def create
      generator = Tokens::Generator.new
      @token = generator.generate(
        admin_user: current_admin_user,
        label: params[:token][:label],
        expires_at: params[:token][:expires_at].presence
      )

      redirect_to admin_token_path(@token), notice: "Token oprettet: #{@token.code}"
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.message
      @token = Token.new
      render :new, status: :unprocessable_entity
    end

    def batch_generate
      count = params[:count].to_i.clamp(1, 100)
      generator = Tokens::Generator.new
      tokens = generator.batch_generate(
        admin_user: current_admin_user,
        count: count,
        label: params[:label]
      )

      redirect_to admin_tokens_path, notice: "#{tokens.size} tokens oprettet"
    end

    def destroy
      token = Token.find(params[:id])
      token.update!(revoked_at: Time.current)
      redirect_to admin_tokens_path, notice: "Token deaktiveret"
    end
  end
end
