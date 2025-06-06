defmodule VerdemindWeb.GeneratePlantLiveTest do
  use VerdemindWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias VerdemindWeb.GeneratePlantLive
  alias Verdemind.Botany.Plant

  import Mox

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

  # Mox: make sure mocks are verified when the test exits
  setup :verify_on_exit!

  describe "LiveView GeneratePlantLive" do
    test "connected mount", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/generate-plant")
      assert view.module == GeneratePlantLive
    end

    test "title correct", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/generate-plant")
      assert html =~ ">Generate Plant</h1>"
    end

    test "form input field for generate_plant name", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/generate-plant")

      assert html =~ "<input"
      assert html =~ "name=\"generate_plant[name]\""
    end

    test "generate plant form renders errors if empty plant name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      result =
        view |> form("#generate-plant-form", generate_plant: %{"name" => ""}) |> render_change()

      assert result =~ "can&#39;t be blank"
    end

    test "generate plant form renders errors if too short plant name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      result =
        view |> form("#generate-plant-form", generate_plant: %{"name" => "Ro"}) |> render_change()

      assert result =~ "should be at least 3 character(s)"
    end

    test "submit plant name, show async loading message and result", %{conn: conn} do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(
        :instruct,
        fn %{messages: messages}, _opts ->
          [%{content: content}] = messages
          :timer.sleep(200)
          {:ok, %Plant{} |> struct!(name: content)}
        end
      )

      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      result =
        view
        |> form("#generate-plant-form", generate_plant: %{"name" => "Rosemary"})
        |> render_submit()

      assert result =~ "asking ChatGPT..."

      async_result = view |> render_async(9000)
      assert async_result =~ ">Name</dt>"
      assert async_result =~ ">Rosemary</dd>"
    end

    test "if :connection_error, submit plant name shows async loading message and error message",
         %{conn: conn} do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(:instruct, fn _, _opts -> {:error, @instructor_response_no_internet} end)

      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      result =
        view
        |> form("#generate-plant-form", generate_plant: %{"name" => "Rosemary"})
        |> render_submit()

      assert result =~ "asking ChatGPT..."

      async_result = view |> render_async(9000)

      assert async_result =~ "<h3>**Connection Error**</h3>"
    end


    test "if error :missing_openai_key, submit plant name shows async loading message and error message",
         %{conn: conn} do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(:instruct, fn _, _opts -> {:error, @instructor_response_no_openai_key} end)

      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      result =
        view
        |> form("#generate-plant-form", generate_plant: %{"name" => "Rosemary"})
        |> render_submit()

      assert result =~ "asking ChatGPT..."

      async_result = view |> render_async(9000)

      assert async_result =~ "<h3>**Missing OPENAI_KEY**</h3>"
    end

    test "if error :other_reason, submit plant name shows async loading message and error message",
         %{conn: conn} do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(:instruct, fn _, _opts -> {:error, "some reason"} end)

      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      result =
        view
        |> form("#generate-plant-form", generate_plant: %{"name" => "Rosemary"})
        |> render_submit()

      assert result =~ "asking ChatGPT..."

      async_result = view |> render_async(9000)
      assert async_result =~ "some reason"
    end
  end
end
