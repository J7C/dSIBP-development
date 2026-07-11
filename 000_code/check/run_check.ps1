$mathExe = "D:\Wolfram Research\Wolfram\15.0\math.exe"
$script = "D:\Agent-projects-nut\dSibp_package\000_code\check\001_check_ibp_seeds.wl"
$stdout = "D:\Agent-projects-nut\dSibp_package\000_code\check\check_stdout.txt"
Start-Process $mathExe -ArgumentList "-noprompt","-script","`"$script`"" -RedirectStandardOutput $stdout -Wait -NoNewWindow
