//
//  PlayerService.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//

import Foundation
import AVFoundation
import Combine

/// AVPlayer wrapper that handles audio playback, seeking, and time observation. Publishes playback state for UI binding.
final class PlayerService: ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var currentTime: TimeInterval = 0
    @Published private(set) var duration: TimeInterval = 0

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var statusObserver: NSKeyValueObservation?

    init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    func play(url: URL) {
        removeTimeObserver()

        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player?.play()
        isPlaying = true

        observeItemDuration(item: item)
        addPeriodicTimeObserver()
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func resume() {
        player?.play()
        isPlaying = true
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            resume()
        }
    }

    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime)
    }

    private func observeItemDuration(item: AVPlayerItem) {
        statusObserver = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            if item.status == .readyToPlay {
                let seconds = item.duration.seconds
                DispatchQueue.main.async {
                    self?.duration = seconds.isFinite ? seconds : 0
                }
            }
        }
    }

    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }

    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        statusObserver?.invalidate()
        statusObserver = nil
        currentTime = 0
        duration = 0
    }

    deinit {
        removeTimeObserver()
    }
}
