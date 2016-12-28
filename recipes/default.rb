#
# Cookbook:: sample-windows
# Recipe:: default
#
# Copyright:: 2016, The Authors, All Rights Reserved.

# windowsの役割と機能の追加をrecipeから行うサンプル

# windows cookbookのwindows_feature resourceを使ったインストール方法
# LWRPを使用するため、v13からは使用不可
windows_feature "Print-LPD-Service" do
  action :install
  all true
  provider :windows_feature_powershell
end

# powershell_script resourceを使ったインストール方法
# パッケージ名はpowershell上で"Get-WindowsFeature"コマンドで確認可能

powershell_script "Install SMTP-Server" do
  code   "Install-WindowsFeature SMTP-Server"
  action :run
  not_if "(Get-WindowsFeature -Name SMTP-Server | Where-Object {$_.InstallState -eq 'Installed'}).Length -gt 0"
end

# 複数の機能を一括でインストールする場合

%w{ NET-Framework-Features Remote-Desktop-Services TFTP-Client}.each do |feature|
  powershell_script "Install #{feature}" do
    code   "Install-WindowsFeature #{feature}"
    action :run
    not_if "(Get-WindowsFeature -Name #{feature} | Where-Object {$_.InstallState -eq 'Installed'}).Length -gt 0"
  end
end
