def vydel(a: float, b: float) -> float:
    if b == 0:
        raise ValueError("Dělení nulou není povoleno.")
    return a / b


def prumer(cisla: list[float]) -> float:
    if not cisla:
        raise ValueError("Průměr prázdného seznamu není definován.")
    return sum(cisla) / len(cisla)
