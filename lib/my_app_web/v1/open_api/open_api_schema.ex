# defmodule MyAppWeb.V1.OpenAPISchema do
#   alias OpenApiSpex.Schema

#   defmodule UserParams do
#     require OpenApiSpex

#     OpenApiSpex.schema(%{
#       title: "UserParams",
#       description: "Parameters required for user authentication",
#       type: :object,
#       properties: %{
#         email: %OpenApiSpex.Schema{type: :string, format: :email, description: "User's email"},
#         password: %OpenApiSpex.Schema{
#           type: :string,
#           format: :password,
#           description: "User's password"
#         }
#       },
#       required: [:email, :password]
#     })
#   end

#   defmodule SessionResponse do
#     require OpenApiSpex

#     OpenApiSpex.schema(%{
#       title: "SessionResponse",
#       description: "Response containing session tokens",
#       type: :object,
#       properties: %{
#         data: %OpenApiSpex.Schema{
#           type: :object,
#           properties: %{
#             access_token: %OpenApiSpex.Schema{type: :string, description: "Access token"},
#             refresh_token: %OpenApiSpex.Schema{type: :string, description: "Refresh token"},
#             access_token_expires_at: %OpenApiSpex.Schema{
#               type: :string,
#               format: :"date-time",
#               description: "Access token expiry time"
#             }
#           }
#         }
#       }
#     })
#   end

#   defmodule MyAppWeb.Schemas.SessionResponse do
#     require OpenApiSpex

#     OpenApiSpex.schema(%{
#       title: "SessionResponse",
#       description: "Response containing session tokens",
#       type: :object,
#       properties: %{
#         data: %OpenApiSpex.Schema{
#           type: :object,
#           properties: %{
#             access_token: %OpenApiSpex.Schema{type: :string, description: "Access token"},
#             refresh_token: %OpenApiSpex.Schema{type: :string, description: "Refresh token"},
#             access_token_expires_at: %OpenApiSpex.Schema{
#               type: :string,
#               format: :"date-time",
#               description: "Access token expiry time"
#             }
#           }
#         }
#       }
#     })
#   end

#   # defmodule SessionParams do
#   #   require OpenApiSpex

#   #   OpenApiSpex.schema(%{
#   #     # The title is optional. It defaults to the last section of the module name.
#   #     # So the derived title for MyApp.User is "User".
#   #     title: "SessionParams",
#   #     description: "Login info for session params",
#   #     type: :object,
#   #     properties: %{
#   #       email: %Schema{type: :string, description: "User Email", format: :email},
#   #       password: %Schema{type: :string, description: "User Password"}
#   #     },
#   #     required: [:email, :password],
#   #     example: %{
#   #       "access_token" => "user@example.com",
#   #       "password" => "userPassword123"
#   #     }
#   #   })
#   # end

#   # defmodule SessionResponse do
#   #   require OpenApiSpex

#   #   OpenApiSpex.schema(%{
#   #     # The title is optional. It defaults to the last section of the module name.
#   #     # So the derived title for MyApp.User is "User".
#   #     title: "Tokens",
#   #     description: "Session tokens",
#   #     type: :object,
#   #     properties: %{
#   #       access_token: %Schema{type: :string, description: "Access Token"},
#   #       refresh_token: %Schema{type: :string, description: "Refresh Token"}
#   #     },
#   #     required: [:access_token, :refresh_token],
#   #     example: %{
#   #       "access_token" =>
#   #         "XCP.JplUMS6HxjQnrsOSxt7ukvhkGxts-FuKkI_ZV7RVbwywyJCJ4vT9MWBueeZpVNUyKYhQBaeqSerSGg6D1gzPymgnJMP8WVwjaVXFvfB9yUgCLwn55anzEr4cZm_cbUfoJh8",
#   #       "refresh_token" =>
#   #         "XCP.oDFpnGvQoE2s6oww2RrPxc8f04pFKIsWfCAPaFl5aKp7cya9ZDve2bd2-zEsJYN0XrS8JZDUyHxt3VbXurF6_DsH_VwGIrjXgRtYYHqQ1KmhFOo9VffJ1l-fqmjPTY1XfGk"
#   #     }
#   #   })

#   #   # OpenApiSpex.schema(%{
#   #   #   title: "UserResponse",
#   #   #   description: "Response schema for single user",
#   #   #   type: :object,
#   #   #   properties: %{
#   #   #     data: User
#   #   #   },
#   #   #   example: %{
#   #   #     "data" => %{
#   #   #       "id" => 123,
#   #   #       "name" => "Joe User",
#   #   #       "email" => "joe@gmail.com",
#   #   #       "birthday" => "1970-01-01T12:34:55Z",
#   #   #       "inserted_at" => "2017-09-12T12:34:55Z",
#   #   #       "updated_at" => "2017-09-13T10:11:12Z"
#   #   #     }
#   #   #   }
#   #   # })
#   # end
# end
