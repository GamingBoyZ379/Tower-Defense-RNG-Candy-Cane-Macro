#Persistent
SetTimer, CheckImages, 50 ; Check every 50 ms for images
SetTimer, UpdateUI, 1000 ; Update UI every second
totalRuntime := 0
totalCandyCanes := 0
scriptStartTime := A_TickCount
imageFound := false  ; Flag to track if any image was found

; Define the directory where the images are stored
scriptDir := A_ScriptDir
imagesDir := scriptDir . "\Images"

; Get the screen width and height of the primary monitor to position the tooltip at the bottom-right (only once)
primaryScreenWidth := A_ScreenWidth
primaryScreenHeight := A_ScreenHeight
tooltipX := primaryScreenWidth - 250  ; Adjust this value for your preferred tooltip width
tooltipY := primaryScreenHeight - 120  ; Adjust this value for your preferred height to leave space for the "Macro By" text

return

CheckImages:
{
    ; Define paths to the images
    greenButtonImage := imagesDir . "\playbutton.png"
    holidayChestImage := imagesDir . "\holidaychest.png" ; Path to the holiday chest image
    candyCaneImages := [imagesDir . "\candycane1.png", imagesDir . "\candycane2.png", imagesDir . "\candycane3.png"]

    ; Search for the green button image
    ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %greenButtonImage%
    if (!ErrorLevel)
    {
        ; Press Enter if the green button is found
        Send, {Enter}
        return
    }

    ; Loop through all the candy cane and holiday chest images
    foundImage := false ; Flag to check if we found any image
    Loop, % candyCaneImages.MaxIndex()
    {
        ; Get the file path of the current image
        currentImage := candyCaneImages[A_Index]

        ; Skip the green button and holiday chest if they're found in the loop
        if (currentImage = greenButtonImage or currentImage = holidayChestImage)
            continue

        ; Search for the current image on the screen
        ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %currentImage%
        if (!ErrorLevel)
        {
            foundImage := true ; Set flag to true if image is found

            ; If holiday chest is found, add 50 candy canes
            if (InStr(currentImage, "holidaychest"))
            {
                totalCandyCanes := totalCandyCanes + 50
            }
            ; For candy cane images, add the corresponding value
            else if (InStr(currentImage, "candycane1"))
            {
                totalCandyCanes := totalCandyCanes + 4
            }
            else if (InStr(currentImage, "candycane2"))
            {
                totalCandyCanes := totalCandyCanes + 5
            }
            else if (InStr(currentImage, "candycane3"))
            {
                totalCandyCanes := totalCandyCanes + 6
            }

            ; Perform the required actions when a candy cane or holiday chest is found
            Send, {Escape}
            Sleep, 50
            Send, l
            Sleep, 50
            Send, {Enter}
            return
        }
    }
}

UpdateUI:
{
    ; Update the total runtime
    totalRuntime := (A_TickCount - scriptStartTime) / 1000 ; Convert milliseconds to seconds

    ; Convert total runtime to hours, minutes, and seconds
    hours := Floor(totalRuntime / 3600)
    minutes := Floor((totalRuntime - (hours * 3600)) / 60)
    seconds := Floor(totalRuntime - (hours * 3600) - (minutes * 60))

    ; Display the tooltip with the updated information at the bottom-right
    tooltipText := "Total Runtime: " . hours . "h " . minutes . "m " . seconds . "s`n"
    tooltipText := tooltipText . "Total Candy Canes: " . totalCandyCanes . "`n"
    tooltipText := tooltipText . "Macro By GamingBoyZ379"  ; Add the "Macro By" text

    Tooltip, % tooltipText, tooltipX, tooltipY
    return
}

GuiClose:
ExitApp
