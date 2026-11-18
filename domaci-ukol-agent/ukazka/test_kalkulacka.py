import unittest

from ukazka.kalkulacka import prumer, vydel


class TestKalkulacka(unittest.TestCase):
    def test_vydel_bezne_hodnoty(self) -> None:
        self.assertEqual(vydel(8.0, 2.0), 4.0)

    def test_vydel_nulou(self) -> None:
        with self.assertRaisesRegex(ValueError, "Dělení nulou"):
            vydel(8.0, 0.0)

    def test_prumer_bezne_hodnoty(self) -> None:
        self.assertEqual(prumer([2.0, 4.0, 6.0]), 4.0)

    def test_prumer_prazdneho_seznamu(self) -> None:
        with self.assertRaisesRegex(ValueError, "prázdného seznamu"):
            prumer([])


if __name__ == "__main__":
    unittest.main()
