source 'https://github.com/CocoaPods/Specs'

platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'Sourcery', '~> 0.10'
end

target 'TeamWork' do
  shared_pods
  pod 'R.swift', '5.0.0.alpha.2'
  pod 'URLNavigator'
  pod 'Kingfisher', '~> 4.10.0'
  pod 'NVActivityIndicatorView'
end

target 'Domain' do
  shared_pods
end

target 'TeamworkAPI' do
    shared_pods
end
