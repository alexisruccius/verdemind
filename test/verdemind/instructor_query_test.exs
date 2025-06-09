defmodule Verdemind.InstructorQueryTest do
  use ExUnit.Case, async: true

  alias Verdemind.InstructorQuery
  alias Verdemind.Botany.Plant

  import Mox

  # Mox: make sure mocks are verified when the test exits
  setup :verify_on_exit!

  @instructor_response_no_openai_key %Req.Response{
    status: 401,
    headers: %{
      "alt-svc" => ["h3=\":443\"; ma=86400"],
      "cf-cache-status" => ["DYNAMIC"],
      "cf-ray" => ["94b310ccea40bb61-FRA"],
      "connection" => ["keep-alive"],
      "content-type" => ["application/json; charset=utf-8"],
      "date" => ["Thu, 05 Jun 2025 22:21:54 GMT"],
      "server" => ["cloudflare"],
      "set-cookie" => [
        "__cf_bm=ycozCVV5j9gOXArOkZFlbls.txAFYBttQSgymVJmCyQ-1749162114-1.0.1.1-dc.auSkVzYKgdSxB_l74QA5F8NqmVeVWCovw9fpRSiBB7sJH4g_dgldYne7fnW560Zqy5I26Iro36jkik4Icux4tKQjcOtOt2ZoJVqiTER4; path=/; expires=Thu, 05-Jun-25 22:51:54 GMT; domain=.api.openai.com; HttpOnly; Secure; SameSite=None",
        "_cfuvid=iSqOyAZlzP_Zt4mPj79Opn0VCByiYCOtYvviPDcFbtM-1749162114248-0.0.1.1-604800000; path=/; domain=.api.openai.com; HttpOnly; Secure; SameSite=None"
      ],
      "strict-transport-security" => ["max-age=31536000; includeSubDomains; preload"],
      "vary" => ["Origin"],
      "x-content-type-options" => ["nosniff"],
      "x-request-id" => ["req_4d0f5cba2a938382bb58bf854f82950a"]
    },
    body: %{
      "error" => %{
        "code" => nil,
        "message" =>
          "You didn't provide an API key. You need to provide your API key in an Authorization header using Bearer auth (i.e. Authorization: Bearer YOUR_KEY), or as the password field (with blank username) if you're accessing the API from your browser and are prompted for a username and password. You can obtain an API key from https://platform.openai.com/account/api-keys.",
        "param" => nil,
        "type" => "invalid_request_error"
      }
    },
    trailers: %{},
    private: %{}
  }

  @instructor_response_no_internet %Req.TransportError{reason: :nxdomain}

  describe "ask/2" do
    test "if successful resturns a map with the given plant ecto schema and the name filled out" do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(
        :instruct,
        fn %{messages: messages}, _opts ->
          [%{content: content}, _] = messages
          {:ok, %Plant{} |> struct!(name: content)}
        end
      )

      content = "Rosemary"
      response_model = Plant

      %{msg: :ok, plant: plant} = InstructorQuery.ask(content, response_model)
      %Plant{name: name} = plant
      assert name == "Rosemary"
    end

    test "if openai key is missing returns a map with error msg and reason" do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(:instruct, fn _, _opts -> {:error, @instructor_response_no_openai_key} end)

      content = "Rosemary"
      response_model = Plant

      %{msg: :missing_openai_key, reason: reason} = InstructorQuery.ask(content, response_model)
      @instructor_response_no_openai_key = reason
    end

    test "if connection error returns a map with error msg and reason" do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(:instruct, fn _, _opts -> {:error, @instructor_response_no_internet} end)

      content = "Rosemary"
      response_model = Plant

      %{msg: :connection_error, reason: reason} = InstructorQuery.ask(content, response_model)
      @instructor_response_no_internet = reason
    end
  end
end
