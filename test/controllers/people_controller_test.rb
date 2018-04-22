require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = people(:one)
  end

  test "should get index" do
    get people_url, as: :json
    assert_response :success
  end

  test "should create person" do
    assert_difference('Person.count') do
      post people_url, as: :json, params: {
        person: {
          born_at: @person.born_at,
          cpf_cnpj: "99999999999",
          fantasy_name: @person.fantasy_name,
          name: @person.name,
          is_juridica: @person.is_juridica
        }
      }
    end

    assert_response 201
  end

  test "should show person" do
    get person_url(@person), as: :json
    assert_response :success
  end

  test "should update person" do
    patch person_url(@person), as: :json, params: {
      person: {
        born_at: @person.born_at,
        cpf_cnpj: @person.cpf_cnpj,
        fantasy_name: @person.fantasy_name,
        name: @person.name,
        is_juridica: @person.is_juridica
      }
    }
    assert_response 200
  end
end
