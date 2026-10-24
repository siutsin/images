// Command which prints the path of a program found on PATH, like which(1).
//
// Threadfin locates ffmpeg by running "which ffmpeg" at startup. A
// distroless runtime ships no which, so this image carries a minimal one
// that does only that lookup.
package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	status := 0
	for _, name := range os.Args[1:] {
		path, err := lookup(name)
		if err != nil {
			status = 1
			continue
		}
		fmt.Println(path)
	}
	os.Exit(status)
}

func lookup(name string) (string, error) {
	if strings.ContainsRune(name, os.PathSeparator) {
		if isExecutable(name) {
			return name, nil
		}
		return "", os.ErrNotExist
	}
	for _, dir := range filepath.SplitList(os.Getenv("PATH")) {
		if dir == "" {
			dir = "."
		}
		candidate := filepath.Join(dir, name)
		if isExecutable(candidate) {
			return candidate, nil
		}
	}
	return "", os.ErrNotExist
}

func isExecutable(path string) bool {
	info, err := os.Stat(path)
	return err == nil && !info.IsDir() && info.Mode().Perm()&0o111 != 0
}
