package main

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestMain(t *testing.T) {
	err := Run()
	if err != nil {
		return
	}
	Foo()
	require.Equal(t, 1, 1)
}

func TestSecond(t *testing.T) {
	require.Equal(t, 1, 1)
}
