# Verdemind

[![Build Status](https://github.com/alexisruccius/verdemind/workflows/CI/badge.svg)](https://github.com/alexisruccius/verdemind/actions/workflows/CI.yml)

Example Elixir project generating plant info with **OpenAI** and **InstructorLite**,
featuring real-time UI via **Phoenix LiveView**, data persistence using **Ecto** with **PostgreSQL**,
and **Mox**-based testing for the **InstructorLite** API.

![Verdemind: Generate a plant, watch LiveView fetch responses from OpenAI](/priv/static/images/verdemind-generate-plant-from-openai.gif)


## Getting Started

To start the `Verdemind` Phoenix app:

1. **Clone the repository:**

   ```sh
   git clone https://github.com/alexisruccius/verdemind.git
   ```

   ```sh
   cd verdemind
   ```

2. **Ensure your PostgreSQL database is set up:**
   - see [Database Setup](#Database-Setup)


3. **Install dependencies and set up the database:**

   ```sh
   mix setup
   ```

4. **Set your OpenAI API key:**

   ```sh
   export OPENAI_KEY="your_openai_key_here"
   ```

5. **Start the Phoenix server in IEx:**

   ```sh
   iex -S mix phx.server
   ```

6. **Query plant data (example):**

   ```elixir
   iex> Verdemind.InstructorQuery.ask("Rosemary", Verdemind.Botany.Plant)
   {:ok,
    %Verdemind.Botany.Plant{
      id: 1,
      name: "Rosemary",
      scientific_name: "Rosmarinus officinalis",
      native_to: "Mediterranean region",
      plant_type: "Herb",
      environment: "Well-drained soil, moderate to dry conditions",
      light_requirements: "Full sun",
      soil: "Well-drained, sandy or loamy soil",
      height: "30 to 90",
      growth_season: "Primarily spring and summer",
      harvesting: "Harvest leaves as needed; for best flavor, cut stems before flowering.",
      how_to_plant: "Plant seeds or cuttings 1 cm deep, spaced 60 cm apart.",
      how_to_water: "Water thoroughly but allow soil to dry between watering to prevent root rot.",
      watering_frequency: "Every 1–2 weeks, depending on soil moisture",
      proliferation: "Seeds or cuttings",
      symbiosis_with: "Thyme, sage, and lavender",
      common_pests: "Spider mites, aphids, and root rot",
      uses: "Culinary (used in cooking meats and stews, flavoring for breads) and medicinal (supports digestion, memory enhancement)",
      location: "Mediterranean regions, commonly grown in gardens and pots worldwide",
      is_this_a_plant: 100,
      ...
    }}
   ```

  Or access the web app:

  Once the server is running, open your browser and visit:
  [http://localhost:4000/generate-plant](http://localhost:4000/generate-plant)


## Database Setup

### PostgreSQL Setup

Install PostgreSQL if you haven't already:
[https://www.postgresql.org/download/](https://www.postgresql.org/download/)

After installation, make sure PostgreSQL is running and create a default superuser:

```sh
createuser -s postgres
psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';"
```

### Configuration

Your database settings in `config/dev.exs` should look like:

```elixir
config :verdemind, Verdemind.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "verdemind_dev",
  ...
```


