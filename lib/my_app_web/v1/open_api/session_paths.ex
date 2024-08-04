defmodule MyAppWeb.V1.OpenAPI.SessionPaths do
  require OpenApiSpex

  alias OpenApiSpex.{Operation, RequestBody, Response, Schema, Parameter}

  @create %Operation{
    summary: "Create a user session",
    tags: ["Session"],
    requestBody: %RequestBody{
      description: "User parameters",
      content: %{
        "application/vnd.api+json" => %{
          "schema" => %{"$ref" => "#/components/schemas/UserSessionParams"}
        }
      }
    },
    responses: %{
      200 => %Response{
        description: "Session response",
        content: %{
          "application/vnd.api+json" => %{
            "schema" => %{"$ref" => "#/components/schemas/SessionResponse"}
          }
        }
      },
      401 => %Response{
        description: "Error response",
        content: %{
          "application/vnd.api+json" => %{
            "schema" => %Schema{
              type: :object,
              properties: %{
                error: %Schema{
                  type: :object,
                  properties: %{
                    status: %Schema{type: :integer},
                    message: %Schema{type: :string}
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  @show %Operation{
    summary: "Get user session",
    tags: ["Session"],
    responses: %{
      200 => %Response{
        description: "Session response",
        content: %{
          "application/vnd.api+json" => %{
            "schema" => %{"$ref" => "#/components/schemas/SessionResponse"}
          }
        }
      },
      401 => %Response{
        description: "Error response",
        content: %{
          "application/vnd.api+json" => %{
            "schema" => %Schema{
              type: :object,
              properties: %{
                error: %Schema{
                  type: :object,
                  properties: %{
                    status: %Schema{type: :integer},
                    message: %Schema{type: :string}
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  @delete %Operation{
    summary: "Delete a user session",
    tags: ["Session"],
    responses: %{
      204 => %Response{description: "No Content"},
      401 => %Response{
        description: "Error response",
        content: %{
          "application/vnd.api+json" => %{
            "schema" => %Schema{
              type: :object,
              properties: %{
                error: %Schema{
                  type: :object,
                  properties: %{
                    status: %Schema{type: :integer},
                    message: %Schema{type: :string}
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  @renew %Operation{
    summary: "Rewew an access token with the refresh token",
    tags: ["Session"],
    parameters: [
      %Parameter{
        name: "X-Refresh-Token",
        in: :header,
        required: true,
        schema: %Schema{
          type: :string
        },
        description: "Refresh token"
      }
    ],
    responses: %{
      200 => %Response{
        description: "Session response",
        content: %{
          "application/vnd.api+json" => %{
            "schema" => %Schema{
              type: :object,
              properties: %{
                access_token: %Schema{
                  type: :string
                }
              },
              required: [:access_token]
            }
          }
        }
      },
      401 => %Response{
        description: "Error response",
        content: %{
          "application/vnd.api+json" => %{
            "schema" => %Schema{
              type: :object,
              properties: %{
                error: %Schema{
                  type: :object,
                  properties: %{
                    status: %Schema{type: :integer},
                    message: %Schema{type: :string}
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  def paths do
    %{
      "/api/v1/session": %{
        post: @create,
        get: @show,
        delete: @delete
      },
      "/api/v1/session/renew": %{
        post: @renew
      }
    }
  end
end
