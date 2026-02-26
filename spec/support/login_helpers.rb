module LoginHelpers
  def log_in(user, password: "password")
    post login_path, params: {
      email: user.email,
      password: password
    }
  end
end
