package main

import (
    "bufio"
    "bytes"
    "encoding/json"
    "fmt"
    "io"
    "log"
    "net/http"
    "os"
    "os/exec"
    "strings"
)

type DuckDuckGoImage struct {
    Image string `json:"image"`
}

type DuckDuckGoResponse struct {
    Results []DuckDuckGoImage `json:"results"`
}
func searchFirstImageDuckDuckGo(query string) (string, error) {
    searchURL := "https://duckduckgo.com/i.js?q=" + strings.ReplaceAll(query, " ", "+")

    client := &http.Client{}
    req, err := http.NewRequest("GET", searchURL, nil)
    if err != nil {
        return "", err
    }

    req.Header.Set("User-Agent", "Mozilla/5.0")
    req.Header.Set("Referer", "https://duckduckgo.com/")
    req.Header.Set("Accept-Language", "en-US,en;q=0.9")  // Add Accept-Language header

    resp, err := client.Do(req)
    if err != nil {
        return "", err
    }
    defer resp.Body.Close()

    body, err := io.ReadAll(resp.Body)
    if err != nil {
        return "", err
    }

    // Log the raw response for debugging
    fmt.Println("Raw DuckDuckGo Response:")
    fmt.Println(string(body))

    var duck DuckDuckGoResponse
    if err := json.Unmarshal(body, &duck); err != nil {
        return "", err
    }

    if len(duck.Results) == 0 {
        return "", fmt.Errorf("no images found")
    }

    return duck.Results[0].Image, nil
}


func downloadImage(url string) ([]byte, error) {
    resp, err := http.Get(url)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()

    return io.ReadAll(resp.Body)
}

func copyImageToClipboard(imageData []byte) error {
    cmd := exec.Command("xclip", "-selection", "clipboard", "-t", "image/png", "-i")
    stdin, err := cmd.StdinPipe()
    if err != nil {
        return err
    }

    if err := cmd.Start(); err != nil {
        return err
    }

    _, err = io.Copy(stdin, bytes.NewReader(imageData))
    if err != nil {
        return err
    }
    stdin.Close()

    return cmd.Wait()
}

func main() {
    reader := bufio.NewReader(os.Stdin)

    for {
        fmt.Print("Enter search query: ")
        query, _ := reader.ReadString('\n')
        query = strings.TrimSpace(query)

        if query == "" {
            fmt.Println("Empty query, skipping...")
            continue
        }

        fmt.Println("Searching for:", query)

        imgURL, err := searchFirstImageDuckDuckGo(query)
        if err != nil {
            log.Println("Error fetching image:", err)
            continue
        }

        fmt.Println("Found Image URL:", imgURL)

        imgData, err := downloadImage(imgURL)
        if err != nil {
            log.Println("Failed to download image:", err)
            continue
        }

        err = copyImageToClipboard(imgData)
        if err != nil {
            log.Println("Failed to copy image to clipboard:", err)
        } else {
            fmt.Println("✅ Image copied to clipboard!")
        }
    }
}

