ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Verdemind.Repo, :manual)

# set Mox's InstructorQuery mock
Mox.defmock(Verdemind.MockInstructorQuery, for: Verdemind.InstructorQuery)
Application.put_env(:verdemind, :instructor_mock, Verdemind.MockInstructorQuery)
