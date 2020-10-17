//
//  ViewController.swift
//  GalleryApp
//
//  Created by Mac on 15/10/20.
//  Copyright © 2020 baljit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var photo: [Photos]? = []
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.jsonparsing()
        }
    
    //URLSESSION
    func jsonparsing()
    {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=100")
            else{
                return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response
            {
                print(response)
            }
            if let data = data
            {
                self.photo = [Photos]()
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [[String: Any]]
                      for eachphotos in json
                        {
                            let photos = Photos()
                            if let urlImage = eachphotos["url"] as? String, let downloadImage = eachphotos["download_url"] as? String
                            {
                                photos.url = urlImage
                                photos.imageUrl = downloadImage
                            }
                            self.photo?.append(photos)
                        }
                    DispatchQueue.main.sync {
                        self.collectionView.reloadData()
                    }
                }
                catch let error
                {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.photo?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imgView.downloadImage(from: (self.photo?[indexPath.item].imageUrl!)!)
        return cell
    }
    

}
extension UIImageView
{
    func downloadImage(from url: String)
    {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil{
                print(error ?? "Unknown")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: collectionWidth/4-2, height: collectionWidth/4-2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

