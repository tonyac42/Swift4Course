//
//  ViewController.swift
//  Music-Kit-Fun
//
//  Created by Tony Coniglio on 2/4/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, MPMediaPickerControllerDelegate {
    
    var mediaPlayer = MPMusicPlayerController()
    
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBAction func chooseTapped(_ sender: Any) {
        let mediaPickerVC = MPMediaPickerController(mediaTypes: .music)
        mediaPickerVC.allowsPickingMultipleItems = false
        mediaPickerVC.popoverPresentationController?.sourceView = view
        mediaPickerVC.delegate = self
        present(mediaPickerVC, animated: true, completion: nil)
    }
    
    @IBAction func randomTapped(_ sender: Any) {
        if let songs = MPMediaQuery.songs().items {
            let randomIndex = arc4random_uniform(UInt32(songs.count - 1))
            let item = songs[Int(randomIndex)]
            playItem(item: item)
        }
    }
    
    @IBAction func playPauseTapped(_ sender: Any) {
        if mediaPlayer.playbackState == .playing {
            mediaPlayer.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            mediaPlayer.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    func playItem(item: MPMediaItem) {
        let imageSize = CGSize(width: 500, height: 500)
        if let albumImage = item.artwork?.image(at: imageSize) {
            artImageView.image = albumImage
            if let title = item.title {
                titleLabel.text = title
            }
        }
        mediaPlayer.setQueue(with: MPMediaItemCollection(items: [item]))
        mediaPlayer.play()
        playPauseButton.setTitle("Pause", for: .normal)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        for item in mediaItemCollection.items {
            playItem(item: item)
        }
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = mediaPlayer.nowPlayingItem {
            let imageSize = CGSize(width: 500, height: 500)
            if let albumImage = item.artwork?.image(at: imageSize) {
                artImageView.image = albumImage
                if let title = item.title {
                    titleLabel.text = title
                }
            }
        }
        if mediaPlayer.playbackState == .playing {
            playPauseButton.setTitle("Play", for: .normal)
        } else if mediaPlayer.playbackState == .paused {
            playPauseButton.setTitle("Pause", for: .normal)
        } else {
            playPauseButton.setTitle("", for: .normal)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
