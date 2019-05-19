//
//  ViewController.swift
//  ARRemote
//
//  Created by Dani Tox on 18/05/2019.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {

    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcADAssistant: MCAdvertiserAssistant!
    
    @IBOutlet var swipeRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConnectivity()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let mcBrowser = MCBrowserViewController(serviceType: "ARPneumatica", session: self.mcSession)
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        print("Swiping...")
        self.view.backgroundColor = .purple
    }
    
    @IBAction func touch(_ sender: UITapGestureRecognizer) {
        print("Touching...")
        
        if mcSession.connectedPeers.count <= 0 { return }
        let packet = Packet(comand: .touch)
        
        do {
            let data = try JSONEncoder().encode(packet)
            print("Sending....")
            try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            self.view.backgroundColor = UIColor.green
        } catch {
            let alert = UIAlertController(title: "Errore", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error)
            self.view.backgroundColor = UIColor.red
        }
        
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//    }

    func setUpConnectivity() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
}

extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected")
        case .connecting:
            print("Connecting...")
        case .notConnected:
            print("Not Connected")
        @unknown default:
            fatalError()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    
}
