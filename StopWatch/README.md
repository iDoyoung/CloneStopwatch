
## Stop watch
- iOS Deployment Target: 13.0
- Xcode Version 13.4.1 
- Library : RxSwift, Firebase, GoogleSignIn
- Design Architecture: MVVM
- 22.7.26 ~ 22.8.1


## Filepath tree
│── Sources
│   ├── Entries
│   │   ├── AppDelegate.swift
│   │   ├── AppDependency.swift
│   │   └── SceneDelegate.swift
│   ├── Models
│   │   ├── Lap.swift
│   │   └── StopwatchTimer.swift
│   ├── Scenes
│   │   ├── Login
│   │   │   ├── LoginRouter.swift
│   │   │   ├── LoginViewController.swift
│   │   │   └── LoginViewModel.swift
│   │   ├── Setting
│   │   │   ├── SettingViewController.swift
│   │   │   └── SettingViewModel.swift
│   │   └── StopWatch
│   │       ├── StopwatchViewController.swift
│   │       ├── StopwatchViewModel.swift
│   │       └── Views
│   │           ├── ControlButton.swift
│   │           └── LapTableViewCell.swift
│   ├── Service
│   │   ├── SocialLoginService.swift
│   │   ├── StopwatchFirestore.swift
│   │   └── TimerManager.swift
│   └── Utils
│       └── Double+ToTime.swift
└── Supportings
    ├── Base.lproj
    │   └── LaunchScreen.storyboard
    ├── GoogleService-Info.plist
    └── Info.plist
