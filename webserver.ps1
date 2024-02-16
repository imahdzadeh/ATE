function new-PowershellWebGUI ($HTMLRaw,$Title,$Runspace) {

    [xml]$xaml = @"
    <Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="$Title" Height="500" Width="700">
        <Grid>
            <DockPanel>
                <WebBrowser Name="WebBrowser" DockPanel.Dock="Top" Margin="30">
                </WebBrowser>
            </DockPanel>
        </Grid>
    </Window>
"@

Add-Type -TypeDefinition @"
    using System.Text;
    using System.Runtime.InteropServices;
    using System.Threading.Tasks;

    //Add For PowerShell Invocation
    using System.Collections.ObjectModel;
    using System.Management.Automation;
    using System.Management.Automation.Runspaces;

    [ComVisible(true)]
    public class PowerShellHelper
    {

        Runspace runspace;

        public PowerShellHelper()
        {
            
            runspace = RunspaceFactory.CreateRunspace();
            runspace.Open();

        }

        public PowerShellHelper(Runspace remoteRunspace)
        {
            
           runspace = remoteRunspace;

        }

        void InvokePowerShell(string cmd, dynamic callbackFunc)
	    {
		    //Init stuff
		    RunspaceInvoke scriptInvoker = new RunspaceInvoke(runspace);
            Pipeline pipeline;

            if(runspace.RunspaceAvailability != RunspaceAvailability.Available) {
                callbackFunc("PowerShell is busy.");
                return;
            }

		    pipeline = runspace.CreatePipeline();

		    //Add commands
		    pipeline.Commands.AddScript(cmd);
            
		    Collection<PSObject> results = pipeline.Invoke();

		    //Convert records to strings
		    StringBuilder stringBuilder = new StringBuilder();
		    foreach (PSObject obj in results)
		    {
			    stringBuilder.Append(obj);
		    }

        
            callbackFunc(stringBuilder.ToString());

	    }

        public void runPowerShell(string cmd, dynamic callbackFunc)
        {
            new Task(() => { InvokePowerShell(cmd, callbackFunc);}).Start();
        }

        public void resetRunspace()
        {

            runspace.Close();
            runspace = RunspaceFactory.CreateRunspace();
		    runspace.Open();

        }

    }
"@ -ReferencedAssemblies @("System.Management.Automation","Microsoft.CSharp","System.Web.Extensions")
 
    [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

    #Read XAML
    $reader=(New-Object System.Xml.XmlNodeReader $xaml) 
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
    #===========================================================================
    # Store Form Objects In PowerShell
    #===========================================================================
    $WebBrowser = $Form.FindName("WebBrowser")
 
    #===========================================================================
    # Use this space to add code to the various form elements in your GUI
    #===========================================================================
    if($Runspace)
    {
        $WebBrowser.ObjectForScripting = [PowerShellHelper]::new($Runspace)
    }
    else
    {
        $WebBrowser.ObjectForScripting = [PowerShellHelper]::new()
    }

    $WebBrowser.NavigateToString($HTMLRaw)

    #===========================================================================
    # Shows the form
    #===========================================================================
    write-host "To show the form, run the following" -ForegroundColor Cyan
    $Form.ShowDialog() | out-null

}

$HTML = @'

<head>
    <script type="text/powershell" id="PowerShellFunctions">
        Function Get-ProcessPerformanceHTML {
            $HTML = gwmi Win32_PerfFormattedData_PerfProc_Process | where {$_.Name -ne "_Total" -and $_.name -ne "Idle"} | select Name, 
                        @{ Name="PID"; Expression={$_.IDProcess} }, 
                        @{ Name="Memory (private working set)"; Expression={"{0:N0} K" -f ($_.WorkingSetPrivate / 1KB)} }, 
                        @{Name="CPU";Expression={$_.PercentProcessorTime}} | 
                        Sort CPU -Desc |
                        ConvertTo-HTML

            return $HTML
        }
    </script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

    <Style>
        .selected {
            background-color: brown;
            color: #FFF;
        }
    </Style>
</head>
<input type="button" id="Refresh" value="Refresh"/>
<input type="button" id="EndTask" value="End Task"/>
<div id="results">Hello</div>

<script>
    refreshRate = 1000;

    returnFunction = function(result) {
      if (result != "PowerShell is busy.") {
        document.getElementById("results").innerHTML = result;

        $("table tr").click(function() {
          $(this).addClass('selected').siblings().removeClass('selected');
          var value = $(this).find('td:first').html();
          alert(value);
        });
      }
    }

    // Loading PowerShell Functions

    var script = document.getElementById('PowerShellFunctions').innerHTML;
    window.external.runPowerShell(script, returnFunction);

    function updateProcesses() {
      window.external.runPowerShell("Get-ProcessPerformanceHTML", returnFunction);
    }

    function endTask(taskName) {
      window.external.runPowerShell("Stop-Process -Name " + taskName, returnFunction);
      setTimeout(function() {
        updateProcesses();
      }, 1000);
    }

    $('#Refresh').on('click', function(e) {
      updateProcesses();
    });

    $('#EndTask').on('click', function(e) {

      var taskName = $("table tr.selected td:first").html();

      alert("Ending Process: " + taskName);
      endTask(taskName);
    });

    updateProcesses();
</script>

'@

New-PowershellWebGUI -HTMLRaw $HTML -Title "The shell"