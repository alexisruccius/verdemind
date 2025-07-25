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
  @valid_plant %Plant{
    name: "some name",
    location: "some location",
    uses: "some uses",
    scientific_name: "some scientific_name",
    native_to: "some native_to",
    plant_type: "some plant_type",
    environment: "some environment",
    light_requirements: "some light_requirements",
    soil: "some soil",
    height: "some height",
    growth_season: "some growth_season",
    harvesting: "some harvesting",
    how_to_plant: "some how_to_plant",
    how_to_water: "some how_to_water",
    watering_frequency: "some watering_frequency",
    proliferation: "some proliferation",
    symbiosis_with: "some symbiosis_with",
    common_pests: "some common_pests",
    is_this_a_plant: 96
  }
  @invalid_plant %Plant{
    name: nil,
    location: nil,
    uses: nil,
    scientific_name: nil,
    native_to: nil,
    plant_type: nil,
    environment: nil,
    light_requirements: nil,
    soil: nil,
    height: nil,
    growth_season: nil,
    harvesting: nil,
    how_to_plant: nil,
    how_to_water: nil,
    watering_frequency: nil,
    proliferation: nil,
    symbiosis_with: nil,
    common_pests: nil,
    is_this_a_plant: 42
  }

  # Mox: make sure mocks are verified when the test exits
  setup :verify_on_exit!

  describe "LiveView GeneratePlantLive" do
    test "connected mount", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/generate-plant")
      assert view.module == GeneratePlantLive
    end

    test "title correct", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/generate-plant")
      assert html =~ ">Plant Generator</h1>"
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

    test "generate plant form renders errors if submit too short plant name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      result =
        view |> form("#generate-plant-form", generate_plant: %{"name" => "Ro"}) |> render_submit()

      assert result =~ "should be at least 3 character(s)"
    end

    test "generate plant form renders errors if submit too long plant name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      too_long_string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do"

      result =
        view
        |> form("#generate-plant-form", generate_plant: %{"name" => too_long_string})
        |> render_submit()

      assert result =~ "should be at most 60 character(s)"
    end

    test "submit plant name, show async loading message and result", %{conn: conn} do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(
        :instruct,
        fn %{messages: messages}, _opts ->
          [%{content: content}, _] = messages
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

      assert async_result =~
               ~s(<input type="text" name="plant[name]" id="plant_name" value="Rosemary")
    end

    test "submit button is hidden if chatGPT loading message", %{conn: conn} do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(
        :instruct,
        fn %{messages: messages}, _opts ->
          [%{content: content}, _] = messages
          :timer.sleep(200)
          {:ok, %Plant{} |> struct!(name: content)}
        end
      )

      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      assert view |> render() =~ "id=\"generate-plant-submit-button\""

      result =
        view
        |> form("#generate-plant-form", generate_plant: %{"name" => "Rosemary"})
        |> render_submit()

      assert result =~ "asking ChatGPT..."
      refute result =~ "id=\"generate-plant-submit-button\""

      async_result = view |> render_async(9000)

      assert async_result =~
               ~s(<input type="text" name="plant[name]" id="plant_name" value="Rosemary")
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

  describe "Plant form in GeneratePlantLive" do
    test "saves new plant from generator", %{conn: conn} do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(
        :instruct,
        fn %{messages: messages}, _opts ->
          [%{content: content}, _] = messages
          :timer.sleep(200)
          {:ok, @valid_plant |> struct!(name: content)}
        end
      )

      {:ok, generate_plant_view, _html} = live(conn, ~p"/generate-plant")

      result =
        generate_plant_view
        |> form("#generate-plant-form", generate_plant: %{"name" => "Rosemary"})
        |> render_submit()

      assert result =~ "asking ChatGPT..."

      async_result = generate_plant_view |> render_async(9000)

      assert async_result =~
               ~s(<input type="text" name="plant[name]" id="plant_name" value="Rosemary")

      assert {:ok, _, html} =
               generate_plant_view
               |> form("#plant-form")
               |> render_submit()
               |> follow_redirect(conn, ~p"/plants")

      assert html =~ "Plant created successfully"
      assert html =~ "Rosemary"
    end

    test "does not save invalid plant from generator and shows validation errors", %{conn: conn} do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(
        :instruct,
        fn %{messages: messages}, _opts ->
          [%{content: content}, _] = messages
          :timer.sleep(200)
          {:ok, @invalid_plant |> struct!(name: content)}
        end
      )

      {:ok, generate_plant_view, _html} = live(conn, ~p"/generate-plant")

      result =
        generate_plant_view
        |> form("#generate-plant-form", generate_plant: %{"name" => "Rosemary"})
        |> render_submit()

      assert result =~ "asking ChatGPT..."

      async_result = generate_plant_view |> render_async(9000)

      assert async_result =~
               ~s(<input type="text" name="plant[name]" id="plant_name" value="Rosemary")

      html = generate_plant_view |> form("#plant-form") |> render_submit()

      assert html =~ "can&#39;t be blank"

      assert html =~
               "Hmm, this might not be a plant. Please generate a new plant or set the confidence above 95."

      assert html =~ "Almost there! A few fields need fixing before we can save this plant."
    end
  end
end
