Class PersianDate
{
    [String]$DisplayHint
    [String]$DateTime   
    [String]$Date       
    [Int]$Day        
    $DayOfWeek
    [int]$DayOfYear
    [int]$DaysInMonth  
    [int]$Hour          
    [int]$Millisecond
    [int]$Minute     
    [MonthName]$Month      
    [int]$Second     
    [int64]$Ticks      
    [TimeSpan]$TimeOfDay  
    [int]$Year
    [String]$Age
}


Enum MonthName
{
   Farvardin = 1
   Ordibehesht = 2
   Khordad = 3
   Tir = 4
   Mordad = 5
   Shahrivar = 6
   Mehr = 7
   Aban = 8
   Azar = 9
   Dey = 10
   Bahman = 11
   Esfand = 12
}
    
    
function Get-PersianDate
{
    param
    (
        [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("LastWriteTime")]
        $Date,
        
        [Parameter(Mandatory=$False)]
        [ValidateRange(1, 9999)]
        $Year,

        [Parameter(Mandatory=$False)]
        [ValidateRange(1, 12)]
        $Month,

        [Parameter(Mandatory=$False)]
        [ValidateRange(1, 31)]
        $Day,

        [Parameter(Mandatory=$False)]
        [ValidateRange(0, 23)]
        $Hour,

        [Parameter(Mandatory=$False)]
        [ValidateRange(0, 59)]
        $Minute,

        [Parameter(Mandatory=$False)]
        [ValidateRange(0, 59)]
        [int]$Second,

        [Parameter(Mandatory=$False)]
        [ValidateRange(0, 999)]
        $Millisecond,

        [Parameter(Mandatory=$False)]
        [Switch]$ToGregorian,

        [Parameter(Mandatory=$False)]
        [ValidateSet("DateTime", "Date","Time")]
        $DisplayHint
       
    )
    Begin
    {
        $PCal = New-Object System.Globalization.PersianCalendar
        $PDate = New-Object PersianDate
        [DateTime]$dateToUse = Get-Date

        
        if (-not $DisplayHint) 
        {
            $DisplayHint = "DateTime"
        }
        
                     
        # use passed date object if specified
        if ($Date)
        {
             $dateToUse = $Date
        }
        
        # use passed year if specified
        if ($Year)
        {
            $offset = $Year - $dateToUse.Year;
            $dateToUse = $dateToUse.AddYears($offset);
        }
        
        # use passed month if specified
        if ($Month)
        {
            $offset = $Month - $dateToUse.Month;
            $dateToUse = $dateToUse.AddMonths($offset);
        }
        
        # use passed day if specified
        if ($Day)
        {
            $offset = $Day - $dateToUse.Day;
            $dateToUse = $dateToUse.AddDays($offset);
        }
        
        # use passed hour if specified
        if ($Hour)
        {
            $offset = $Hour - $dateToUse.Hour;
            $dateToUse = $dateToUse.AddHours($offset);
        }
        
        # use passed minute if specified
        if ($Minute)
        {
            $offset = $Minute - $dateToUse.Minute;
            $dateToUse = $dateToUse.AddMinutes($offset);
        }
        
        # use passed second if specified
        if ($Second)
        {
            $offset = $Second - $dateToUse.Second;
            $dateToUse = $dateToUse.AddSeconds($offset);
        }
        
        # use passed millisecond if specified
        if ($Millisecond)
        {
            $offset = $Millisecond - $dateToUse.Millisecond;
            $dateToUse = $dateToUse.AddMilliseconds($offset);
            $dateToUse = $dateToUse.Subtract([Timespan]::FromTicks($dateToUse.Ticks % 10000));
        }
    }

    Process
    {
        #Age Calculation
        [datetime]$birthday = $dateToUse
        $span = [datetime]::Now - $birthday
        if ($span -gt 0)
        {
            $age = New-Object DateTime -ArgumentList $Span.Ticks
            $PDate.Age =  [String]($age.Year -1) + " Years " + [String]($age.Month -1) + " Months " + [String]($age.Day -1 ) + " days " + [String]$age.Hour + " hours " + [String]$age.Minute + " minutes " + [String]$age.second + " seconds "
        }
        


        if (-Not $ToGregorian)
        {
            $PDate.Day = $PCal.GetDayOfMonth($dateToUse)
            $pdate.DayOfYear = $PCal.GetDayOfYear($dateToUse)
            $pdate.DayOfWeek = $dateToUse.DayOfWeek
            $PDate.Month = $PCal.GetMonth($dateToUse)
            $PDate.Year = $PCal.GetYear($dateToUse)
            $PDate.Date = ([String]$PDate.Year + "/" + [String]$PDate.Month.value__ + "/" + [String]$PDate.Day)
            $PDate.DaysInMonth = $PCal.GetDaysInMonth($PDate.Year,$PDate.Month)

            Switch ($DisplayHint)
            {
                "DateTime"
                {
                    $PDate.DateTime = ([string]$PDate.DayOfWeek + ", " + [String]$PDate.Day + " " + $PDate.Month + ", " + [String]$PDate.Year + " " + $dateToUse.ToString("hh:mm:ss"))                
                }
                "Date"
                {
                    $PDate.DateTime = ([string]$PDate.DayOfWeek + ", " + [String]$PDate.Day + " " + $PDate.Month + ", " + [String]$PDate.Year)
                }
                "Time"
                {
                    $PDate.DateTime = $dateToUse.ToString("hh:mm:ss tt")
                }
            }

            
            $pdate.DisplayHint = $DisplayHint
            $PDate.Hour = $dateToUse.Hour
            $pdate.Minute = $dateToUse.Minute
            $PDate.Millisecond = $dateToUse.Millisecond
            $PDate.Second = $dateToUse.Second
            $PDate.Ticks = $dateToUse.Ticks
            $PDate.TimeOfDay = $dateToUse.TimeOfDay
            

            Return $PDate
        }

        #Convert Persian Date to Gregorian Date
        Return $PCal.ToDateTime($dateToUse.Year,$dateToUse.Month,$dateToUse.Day,$dateToUse.Hour,$dateToUse.Minute,`
        $dateToUse.Second,$dateToUse.Millisecond)
    }
}