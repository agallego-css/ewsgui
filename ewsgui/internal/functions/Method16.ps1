﻿Function Method16 {
    <#
    .SYNOPSIS
    Method to remove OWA configurations.
    
    .DESCRIPTION
    Method to remove OWA configurations.
    
    .EXAMPLE
    PS C:\> Method16
    Method to remove OWA configurations.

    #>
    [CmdletBinding()]
    param(
        # Parameters
    )
    $statusBar.Text = "Running..."
    $output = "Checking" + $ComboOption2
    $txtBoxResults.Text = $output
    $txtBoxResults.Visible = $True
    $PremiseForm.Refresh()

    $fid = $null
    if ( $ComboOption1 -eq "Root" )
    {
        $fid = New-Object Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Root, $email)
    }
    elseif ( $ComboOption1 -eq "Calendar" )
    {
        $fid = New-Object Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Calendar, $email)
    }
    elseif ( $ComboOption1 -eq "Inbox" )
    {
        $fid = New-Object Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Inbox, $email)
    }
    
    if ( $ComboOption2 -ne "CleanFinders" )
    {
        try
        {
            $Config = [Microsoft.Exchange.WebServices.Data.UserConfiguration]::Bind($Service, $ComboOption2, $fid, [Microsoft.Exchange.WebServices.Data.UserConfigurationProperties]::All)
            $Config.Delete();
            $output = $output + $nl + "Deleted $ComboOption2"
        }
        catch
        {
            $output = $output + $nl + "$ComboOption2 doesn't exist"
        }
        $statusBar.Text = "Ready..."
        Write-PSFMessage -Level Host -Message "Task finished succesfully" -FunctionName "Method 16"
        $txtBoxResults.Text = $output
        $txtBoxResults.Visible = $True
        $PremiseForm.Refresh()

    }
    else
    {
        # Creating folder object (SearchFolders also know as Finder)
        $folderid = new-object Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::SearchFolders,$SmtpAddress)

        # Opening the bind to user Folder Finder
        $output = $output + $nl + "Opening Mailbox: $email"
        try
        {
            $finderFolder = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($Service,$folderid)
            $output = $output + $nl + "Cleaning SearchFolder (same as Outlook /Cleanfinders)"

            # If the bind was created, clean the folder Finder
            Try
            {
                $finderFolder.Empty([Microsoft.Exchange.WebServices.Data.DeleteMode]::SoftDelete, $true)
                $output = $output + $nl + "The Cleanup process for the Mailbox: $email Succeed!"
            }
            catch
            {
                $output = $output + $nl + "Fail to clean Search folder Mailbox: $email"
            }
        }
        catch
        {
            $output = $output + $nl + "Fail to open Mailbox: $email"
        }
        $txtBoxResults.Text = $output
        $txtBoxResults.Visible = $True
        $statusBar.Text = "Ready..."
        Write-PSFMessage -Level Host -Message "Task finished succesfully" -FunctionName "Method 16"
        $PremiseForm.Refresh()

        #Cleaning Variables
        $SmtpAddress = $null
        $finderFolder = $null
        $folderid = $null
    }
}