module LoginHelpers
  def log_in(user)
    post login_path, params: {
      email: user.email,
      password: "password"
    }
  end
end
