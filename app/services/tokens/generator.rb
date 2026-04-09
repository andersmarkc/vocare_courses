module Tokens
  class Generator
    CHARSET = ("A".."Z").to_a + ("0".."9").to_a

    def generate(admin_user:, label: nil, expires_at: nil)
      code = unique_code
      Token.create!(
        code: code,
        created_by: admin_user,
        label: label,
        expires_at: expires_at
      )
    end

    def batch_generate(admin_user:, count:, label: nil, expires_at: nil)
      count.times.map do
        generate(admin_user: admin_user, label: label, expires_at: expires_at)
      end
    end

    private

    def unique_code
      loop do
        code = "VOCARE-#{random_segment}-#{random_segment}"
        return code unless Token.exists?(code: code)
      end
    end

    def random_segment
      4.times.map { CHARSET.sample }.join
    end
  end
end
