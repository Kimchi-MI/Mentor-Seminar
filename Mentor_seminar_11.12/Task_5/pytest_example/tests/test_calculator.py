# tests/test_calculator.py

import sys
import os
import pytest


# Добавляем путь к корневой директории проекта
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))


def test_add(calc):
    assert calc.add(2, 3) == 5
    assert calc.add(-1, 1) == 0
    assert calc.add(-1, -1) == -2

def test_subtract(calc):
    assert calc.subtract(10, 5) == 5
    assert calc.subtract(-1, -1) == 0
    assert calc.subtract(-1, 1) == -2

@pytest.mark.parametrize(
    "base, exponent, expected",
    [
        (2, 3, 8),
        (1, 5, 1),
        (0, 5, 0),
        (5, 0, 1),
        (-2, 3, -8),
        (2, -2, 0.25),
    ]
)
def test_power(calc, base, exponent, expected):
    assert calc.power(base, exponent) == expected

@pytest.mark.slow

@pytest.mark.slow
def test_heavy_computation(calc):
    import time
    time.sleep(5)  # Симуляция долгой операции
    assert calc.multiply(1000, 1000) == 1000000

@pytest.mark.skipif(sys.platform == "win32", reason="Does not run on Windows")
def test_specific_platform(calc):
# Тест, специфичный для Unix-систем
    assert calc.divide(10, 2) == 5
