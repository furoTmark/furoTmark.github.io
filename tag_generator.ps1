Write-Host Tag Generator for Jekyll -ForegroundColor Green
Write-Host 
Write-Host Copyright 2018 Furó Tamás-Márk -ForegroundColor Green
Write-Host Github: "@furoTmark" -ForegroundColor Green
Write-Host 
Write-Host This script creates tags for your Jekyll blog hosted by Github page. -ForegroundColor Green
Write-Host No plugins required. -ForegroundColor Green
Write-Host Powershell version of Long Qian``s pyton script. -ForegroundColor Green
Write-Host 
$newLine = "`r`n"
$postDir="_posts"
$tagDir="tag"
$crawl=$false
$total_tags=@()
foreach($Item in $(Get-Childitem –Path ".\$postDir" -Include *.md -Recurse))
{
    Write-Host Looking for tags in file: $Item  -ForegroundColor Green
    foreach($line in Get-Content $Item){
        if($crawl){
            $current_tags = $line -split " "
            if($current_tags[0] -eq "tags:"){
                $total_tags += $current_tags[1..($current_tags.Length-1)]
                Write-Host Tags found: $total_tags -ForegroundColor Green
                $crawl=false
                break
            }

        }
        if($line -eq "---"){
            if(-not $crawl ){
                $crawl=$true
            }else{
                Write-Host No tags found -ForegroundColor Green
                break
            }
        }
    }
    Write-Host 
}

Write-Host Recreating tag directory -ForegroundColor Green
Remove-Item -Path ".\$tagDir" -Recurse -ErrorAction Ignore
New-Item -Path ".\$tagDir" -ItemType directory

foreach($tag in $total_tags){
    $tag_filename = ".\$tagDir\$tag.md"
    $write_str = '---' + $newLine + 'layout: tagpage' + $newLine + 'title: "Tag: ' + $tag + '"' + $newLine +'tag: ' + $tag + $newLine +'robots: noindex' + $newLine + '---' + $newLine 
    Set-Content -Value $write_str -Path $tag_filename
}

Write-Host Created markdowns for the following tags: $total_tags -ForegroundColor Green