# tests/conftest.py
import sys
import os

# Добавляем путь к родительской директории (где лежит calculator.py)
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import pytest
from calculator import Calculator

@pytest.fixture
def calc():
    return Calculator()
