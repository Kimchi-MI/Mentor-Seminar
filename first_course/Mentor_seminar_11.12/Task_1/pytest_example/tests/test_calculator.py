# tests/test_calculator.py

import sys
import os

# Добавляем путь к корневой директории проекта
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import calculator

def test_add():
    assert calculator.add(2, 3) == 5

def test_subtract():
    assert calculator.subtract(10, 5) == 5

def test_multiply():
    assert calculator.multiply(3, 4) == 12

def test_divide():
    assert calculator.divide(10, 2) == 5

def test_divide_by_zero():
    import pytest
    with pytest.raises(ValueError) as exc_info:
        calculator.divide(10, 0)
    assert str(exc_info.value) == "Cannot divide by zero"
