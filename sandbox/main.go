package main

import (
	"fmt"
	"math/rand"
)

type ITest interface {
}
type Test struct {
	A string
}

func testFn(a string, b bool) error {
	return nil
}

func init() {
	rnd := rand.New(rand.NewSource(0))
}

func main() {
	var test int = 1

	var hello ITest
	hello = Test{A: "Test"}

	if err := testFn("test", false); err != nil {
		panic(err)
	}

	test = 2
	fmt.Println("hello")
}
