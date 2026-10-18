package main

import (
	"fmt"
	"math"
	"sort"
)

func main() {
	var n int
	fmt.Print("Сколько чисел будете вводить? ")
	if _, err := fmt.Scan(&n); err != nil || n < 1 {
		fmt.Println("Ошибка - количество должно быть целым числом >= 1")
		return
	}

	nums := make([]float64, 0, n)
	sum := 0.0
	for i := 1; i <= n; i++ {
		var x float64
		fmt.Printf("Число %d: ", i)
		if _, err := fmt.Scan(&x); err != nil {
			fmt.Println("Ошибка - нужно ввести число")
			return
		}
		nums = append(nums, x)
		sum += x
	}

	mean := sum / float64(n)

	// Min Max
	minV, maxV := nums[0], nums[0]
	for _, x := range nums {
		if x < minV {
			minV = x
		}
		if x > maxV {
			maxV = x
		}
	}

	// Медиана
	sorted := make([]float64, n)
	copy(sorted, nums)
	sort.Float64s(sorted)
	var median float64
	if n%2 == 1 {
		median = sorted[n/2]
	} else {
		median = (sorted[n/2-1] + sorted[n/2]) / 2
	}

	// Дисперсия и стандартное отклонение 
	variance := 0.0
	for _, x := range nums {
		variance += (x - mean) * (x - mean)
	}
	variance /= float64(n)

	fmt.Printf("Количество: %d\n", n)
	fmt.Printf("Сумма: %g\n", sum)
	fmt.Printf("Среднее: %.2f\n", mean)
	fmt.Printf("Минимум: %g\n", minV)
	fmt.Printf("Максимум: %g\n", maxV)
	fmt.Printf("Размах: %g\n", maxV-minV)
	fmt.Printf("Медиана: %.2f\n", median)
	fmt.Printf("Дисперсия: %.2f\n", variance)
	fmt.Printf("Стандартное отклонение: %.2f\n", math.Sqrt(variance))
}
