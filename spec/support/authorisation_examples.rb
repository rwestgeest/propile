shared_examples_for "a guarded singular resource controller" do |*args|
  roles, options = split_args_in_roles_and_options(args)
  options = {} unless options
  options.default = []
  action_procs = {
    :show => lambda { |context| context.get :show },
    :edit => lambda { |context| context.get :edit },
    :update => lambda { |context| context.put :update, "these" => "attributes"}
  }
  actions = action_procs.keys - options[:except]
  # let(:actions) { [:index, :new, :create, :edit, :delete] - options[:except] }
  describe "when not logged in" do
    actions.each do |action|
      it "redirects to home when attempting #{action}" do
        action_procs[action].call(self)
        response.should be_redirect
        response.should redirect_to(new_account_session_path)
      end
    end
  end

  (ActionGuard.valid_roles - roles).each do |role|
    describe "when logged in as #{role}" do
      login_as role
      actions.each do |action|
        it "signs_out when attempting #{action}" do
          get action
          controller.signed_in?.should be_false
        end
      end
    end
  end
end

shared_examples_for "a guarded resource controller" do |*args|
  roles, options = split_args_in_roles_and_options(args)
  options = {} unless options
  options.default = []
  nested_params = options.has_key?(:nested_params) && options[:nested_params] || {}

  action_procs = {
    :index => lambda { |context| context.get :index, nested_params  },
    :new => lambda { |context| context.get :new, nested_params },
    :show => lambda { |context| context.get:show, nested_params.merge(:id => 1) },
    :edit => lambda { |context| context.get :edit, nested_params.merge(:id => 1) },
    :create => lambda { |context| context.post :create, nested_params.merge(:id => 1, "these" => "attributes")},
    :update => lambda { |context| context.put :update, nested_params.merge(:id => 1, "these" => "attributes")},
    :destroy => lambda { |context| context.delete :destroy, nested_params.merge(:id => 1) }
  }
  actions = action_procs.keys - options[:except]
  # let(:actions) { [:index, :new, :create, :edit, :delete] - options[:except] }
  describe "when not logged in" do
    actions.each do |action|
      it "redirects to home when attempting #{action}" do
        action_procs[action].call(self)
        response.should be_redirect
        response.should redirect_to(new_account_session_path)
      end
    end
  end

  (ActionGuard.valid_roles - roles).each do |role|
    describe "when logged in as #{role}" do
      login_as role
      actions.each do |action|
        it "signs_out when attempting #{action} as #{role}" do
          action_procs[action].call(self)
          controller.signed_in?.should be_false
        end
      end
    end
  end
end

private
def split_args_in_roles_and_options(args)
  if args.last.is_a?(Hash)
    [stringify_these(args[0, args.length-1]), args.last]
  else
    [stringify_these(args), {}]
  end
end
def stringify_these(roles)
  roles.collect { |role| role.to_s } 
end

