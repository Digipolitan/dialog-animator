Pod::Spec.new do |s|
s.name = "DGDialogAnimator"
s.version = "1.0.0"
s.summary = "UIView animator used to display dialog"
s.homepage = "https://github.com/Digipolitan/dialog-animator-swift"
s.authors = "Digipolitan"
s.source = { :git => "https://github.com/Digipolitan/dialog-animator.git", :tag => "v#{s.version}" }
s.license = { :type => "BSD", :file => "LICENSE" }
s.source_files = 'Sources/**/*.{swift,h}'
s.ios.deployment_target = '8.0'
s.tvos.deployment_target = '9.0'
s.requires_arc = true
end
