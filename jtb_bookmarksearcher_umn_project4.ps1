# Prompt user for keyword input
$keyword = Read-Host "Enter the keyword to search"

# Prompt user for file path input
$filePath = Read-Host "Enter the path to the HTML bookmarks file"

# Read the contents of the bookmarks file
$bookmarksContent = Get-Content -Path $filePath -Raw

# Extract URLs from the bookmarks file using regex
$urls = [regex]::Matches($bookmarksContent, '<A HREF="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }

# Initialize an empty array to store URLs where the keyword was found
$matchedUrls = @()

# Loop through each URL and fetch its content using Invoke-WebRequest
foreach ($url in $urls) {
    Write-Host "Fetching content from $url ..."
    $content = Invoke-WebRequest -Uri $url -ErrorAction SilentlyContinue
    
    # Search for the keyword in the fetched content
    if ($content.Content -match $keyword) {
        $matchedUrls += [PSCustomObject]@{
            URL = $url
        }
    }
}

# Print the URLs where the keyword was found as a table
if ($matchedUrls.Count -gt 0) {
    Write-Host "***** Here are the URLs where your keyword was found: *****"
    $matchedUrls | Format-Table -Property URL -AutoSize
}
