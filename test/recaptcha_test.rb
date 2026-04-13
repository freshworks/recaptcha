require_relative 'helper'

describe "Recaptcha" do
  describe ".skip_env?" do
    # test/helper.rb deletes RAILS_ENV and RACK_ENV, so default_env is nil in this suite.
    # This mirrors what can happen in multi-threaded servers (e.g. Puma running system tests)
    # where the Configuration singleton is initialised before the env var is visible,
    # leaving default_env as nil even though Rails.env correctly returns "test".

    it "returns true when env argument matches skip_verify_env" do
      assert Recaptcha.skip_env?("test")
    end

    it "returns false when env argument is not in skip_verify_env" do
      refute Recaptcha.skip_env?("production")
    end

    it "returns false when env argument is nil and default_env is nil" do
      assert_nil Recaptcha.configuration.default_env
      refute Recaptcha.skip_env?(nil)
    end

    describe "when Rails.env is available and in skip_verify_env" do
      before do
        rails_stub = Module.new { def self.env; "test"; end }
        Object.const_set(:Rails, rails_stub)
      end

      after do
        Object.send(:remove_const, :Rails) if defined?(Rails)
      end

      it "returns true even when default_env is nil" do
        assert_nil Recaptcha.configuration.default_env
        assert Recaptcha.skip_env?(nil)
      end
    end
  end
end
