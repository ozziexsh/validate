rules = %{
  "email" => [
    required: true,
    type: :string,
    min: 0,
    max: 100,
  ],
  "colors" => [
    required: true,
    type: :list,
    list: [
      required: true,
      type: :string,
    ]
  ]
  "friends" => [
    required: true,
    type: :list,
    list: [
      required: true,
      map: %{
        "name" => [
          required: true,
          type: :string
        ]
      }
    ]
  ],
  "address" => [
    required: true,
    type: :map,
    map: %{
      "line1" => [
        required: true,
        type: :string,
      ],
      "country" => [
        required: true,
        type: :string
      ]
    }
  ]
}

input = %{
  "email" => "",
  "colors" => ["blue", "orange", 2]
  "friends" => [
    %{ "name" => "oz" },
    %{ "name" => "" },
  ],
  "address" => %{
    "line1" => "123 fake st",
    "country" => ""
  },
  "unused" => "this should not be in the final data"
}

errors = [
  %{
    path: ["email"],
    rule: :required,
    message: "value is required"
  },
  %{
    path: ["colors", 2],
    rule: :string,
    message: "value must be a string"
  },
  %{
    path: ["friends", 1, "name"],
    rule: :required,
    message: "value is required"
  }
]

errors_formatted = %{
  "email" => ["value is required"],
  "colors.2" => ["value must be a string"],
  "friends.1.name" => ["value is required"]
}
