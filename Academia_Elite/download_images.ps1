$images = @(
    @{ Id=1; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Colombia_road_sign_SR-01.svg/600px-Colombia_road_sign_SR-01.svg.png" },
    @{ Id=2; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Traffic_light_red.svg/480px-Traffic_light_red.svg.png" },
    @{ Id=3; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Colombia_road_sign_SP-01.svg/600px-Colombia_road_sign_SP-01.svg.png" },
    @{ Id=4; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Colombia_road_sign_SR-04.svg/600px-Colombia_road_sign_SR-04.svg.png" },
    @{ Id=5; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Colombia_road_sign_SR-28.svg/600px-Colombia_road_sign_SR-28.svg.png" },
    @{ Id=6; Url="https://cdn-icons-png.flaticon.com/512/3209/3209867.png" },
    @{ Id=7; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Colombia_road_sign_SP-47.svg/600px-Colombia_road_sign_SP-47.svg.png" },
    @{ Id=8; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Colombia_road_sign_SI-05.svg/600px-Colombia_road_sign_SI-05.svg.png" },
    @{ Id=9; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/7/79/Traffic_light_yellow.svg/480px-Traffic_light_yellow.svg.png" },
    @{ Id=10; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Colombia_road_sign_SR-02.svg/600px-Colombia_road_sign_SR-02.svg.png" },
    @{ Id=11; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Colombia_road_sign_SR-30_30.svg/600px-Colombia_road_sign_SR-30_30.svg.png" },
    @{ Id=12; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Road_marking_double_yellow_line.svg/600px-Road_marking_double_yellow_line.svg.png" },
    @{ Id=13; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Colombia_road_sign_SR-02A.svg/600px-Colombia_road_sign_SR-02A.svg.png" },
    @{ Id=14; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Colombia_road_sign_SR-06.svg/600px-Colombia_road_sign_SR-06.svg.png" },
    @{ Id=15; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Colombia_road_sign_SP-25.svg/600px-Colombia_road_sign_SP-25.svg.png" },
    @{ Id=16; Url="https://cdn-icons-png.flaticon.com/512/4688/4688220.png" },
    @{ Id=17; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Colombia_road_sign_SI-21.svg/600px-Colombia_road_sign_SI-21.svg.png" },
    @{ Id=18; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Colombia_road_sign_SP-46.svg/600px-Colombia_road_sign_SP-46.svg.png" },
    @{ Id=19; Url="https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Colombia_road_sign_SP-21.svg/600px-Colombia_road_sign_SP-21.svg.png" },
    @{ Id=20; Url="https://cdn-icons-png.flaticon.com/512/2805/2805527.png" }
)

$destDir = "c:\Users\visitante\Desktop\academia-app\Academia_Elite\images\trivia"

foreach ($img in $images) {
    $outFile = Join-Path $destDir "$($img.Id).png"
    Write-Host "Downloading $($img.Id)..."
    try {
        Invoke-WebRequest -Uri $img.Url -OutFile $outFile -UserAgent "Mozilla/5.0"
    } catch {
        Write-Host "Error downloading $($img.Id): $_"
        # Create a dummy file if download fails to prevent broken links
        $dummyContent = [System.Text.Encoding]::ASCII.GetBytes("Placeholder")
        [System.IO.File]::WriteAllBytes($outFile, $dummyContent)
    }
}
Write-Host "Done."
