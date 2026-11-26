
require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:user_one)
  end

  test "should get index" do
    get todos_path
    assert_response :success
  end

  test "should get new" do
    get new_todo_path
    assert_response :success
  end

  test "should get show" do
    get todo_path(todos(:user_one_todo))
    assert_response :success
  end

  test "should get edit" do
    get edit_todo_path(todos(:user_one_todo))
    assert_response :success
  end

  test "user can sign out" do
    delete session_path

    assert_response :see_other
    assert_redirected_to new_session_path

    get root_path
    assert_redirected_to new_session_path
  end

  test "user cannot access another user's todo" do
  other_user_todo = todos(:user_two_todo)

  get todo_path(other_user_todo)

  assert_response :not_found
end
test "happy flow: login, create todo and complete it" do
  post session_path, params: {
    email_address: "user1@example.com",
    password: "password123"
  }

  assert_redirected_to root_path

  post todos_path, params: {
    todo: {
      title: "My first Todo",
      description: "Testing the Todo app"
    }
  }

  todo = users(:user_one).todos.last

  assert_equal "My first Todo", todo.title
  assert_equal "pending", todo.status

  patch todo_path(todo), params: {
    todo: { status: "completed" }
  }

  assert_redirected_to todos_path
  assert_equal "completed", todo.reload.status
end
test "user two can create and complete their own todo" do
  post session_path, params: {
    email_address: "user2@example.com",
    password: "password456"
  }

  assert_redirected_to root_path

  post todos_path, params: {
    todo: {
      title: "My Ruby Practice",
      description: "Practice Rails with Ruby"
    }
  }

  todo = users(:user_two).todos.last

  assert_equal "My Ruby Practice", todo.title
  assert_equal "pending", todo.status

  patch todo_path(todo), params: {
    todo: { status: "completed" }
  }

  assert_redirected_to todos_path
  assert_equal "completed", todo.reload.status
end
end
