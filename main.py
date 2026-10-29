import argparse
import json
import os

from openai import OpenAI


MAX_TOOL_ROUNDS = 8

TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "calculate",
            "description": "Proveď základní matematickou operaci se dvěma čísly.",
            "parameters": {
                "type": "object",
                "properties": {
                    "a": {"type": "number", "description": "První číslo"},
                    "b": {"type": "number", "description": "Druhé číslo"},
                    "operation": {
                        "type": "string",
                        "enum": ["add", "subtract", "multiply", "divide"],
                        "description": "Operace: sčítání, odčítání, násobení nebo dělení",
                    },
                },
                "required": ["a", "b", "operation"],
                "additionalProperties": False,
            },
        },
    }
]


def calculate(a: float, b: float, operation: str) -> float:
    """Proveď pouze povolenou základní aritmetickou operaci."""
    operations = {
        "add": lambda: a + b,
        "subtract": lambda: a - b,
        "multiply": lambda: a * b,
        "divide": lambda: a / b,
    }
    if operation not in operations:
        raise ValueError(f"Nepodporovaná operace: {operation}")
    return operations[operation]()


def ask_llm(question: str) -> str:
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise SystemExit("Nastavte proměnnou prostředí OPENAI_API_KEY.")

    client = OpenAI(api_key=api_key)
    model = os.getenv("OPENAI_MODEL", "gpt-4o-mini")
    messages = [
        {
            "role": "system",
            "content": "Odpovídej česky. Pro výpočty použij nástroj calculate.",
        },
        {"role": "user", "content": question},
    ]

    for _ in range(MAX_TOOL_ROUNDS):
        response = client.chat.completions.create(
            model=model,
            messages=messages,
            tools=TOOLS,
            tool_choice="auto",
        )
        message = response.choices[0].message
        messages.append(message)

        if not message.tool_calls:
            return message.content or ""

        for tool_call in message.tool_calls:
            if tool_call.function.name != "calculate":
                raise ValueError(f"Neznámý nástroj: {tool_call.function.name}")

            arguments = json.loads(tool_call.function.arguments)
            try:
                result = calculate(**arguments)
                tool_result = {"result": result}
            except (ValueError, ZeroDivisionError) as error:
                tool_result = {"error": str(error)}

            messages.append(
                {
                    "role": "tool",
                    "tool_call_id": tool_call.id,
                    "content": json.dumps(tool_result, ensure_ascii=False),
                }
            )

    raise RuntimeError(f"Model překročil limit {MAX_TOOL_ROUNDS} volání nástrojů.")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Zeptej se LLM; při výpočtu může použít kalkulačku."
    )
    parser.add_argument("question", nargs="+", help="Otázka pro LLM")
    args = parser.parse_args()
    print(ask_llm(" ".join(args.question)))


if __name__ == "__main__":
    main()
