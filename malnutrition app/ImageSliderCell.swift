import UIKit

class ImageSliderCell:UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var element:Element?;
    
    let defaultTintColor = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
    let defaultSeparatorColor = UIColor(colorLiteralRed: 200/255, green: 199/255, blue: 204/255, alpha: 1.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var optionsStackViewHolder: UIStackView?;
    var collectionViewHolder: UICollectionView?;
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    func setElement(element: Element){
//        
//    }
//    
    func set(element: Element){
        if(collectionView == nil){
            collectionView = collectionViewHolder;
        }
        self.element = element;
        if(collectionView != nil){
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
        }
        if(element._images?.count == 0){
            if(collectionView != nil){
                collectionViewHolder = collectionView;
                collectionView.removeFromSuperview();
            }
        }
        //TODO: add some code to get the images from the urls
        
        collectionView.reloadData();
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell;
        let imageView = cell.imageView
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(imageTapped(gestureRecognizer:)))
        imageView?.isUserInteractionEnabled = true
        imageView?.addGestureRecognizer(tapGestureRecognizer)
        
        cell.updateImageUrlString(url: (self.element?._images?[indexPath.row])!);
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (element?._images!.count)!
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImageView = gestureRecognizer.view! as! UIImageView
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : PictureViewController = storyBoard.instantiateViewController(withIdentifier: "PictureViewController") as! PictureViewController
        controller.setImage(image: tappedImageView.image!)
        let topViewController = UIApplication.topViewController();
        topViewController?.present(controller, animated: true, completion: nil)
    }
}
