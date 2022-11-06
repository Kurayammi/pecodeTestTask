//
//  ArticlesDatabaseManager.swift
//  Pecode Test
//
//  Created by Kito on 11/6/22.
//

import CoreData
import UIKit

final class ArticlesDatabaseManager {
    
    private var managedContext: NSManagedObjectContext?  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else { return nil }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
    func saveArticleToCoreData(articleToSave: ArticlesModel) {
        
        print("start save to coreData")
        
        guard let managedContext = managedContext else { return}
        guard let entity = NSEntityDescription.entity(forEntityName: "Article",
                                                      in: managedContext) else { return }
        
        let article = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        
        article.setValue(articleToSave.title, forKey: "title")
        article.setValue(articleToSave.description, forKey: "detailsInfo")
        article.setValue(articleToSave.publishedAt, forKey: "publishedAt")
        article.setValue(articleToSave.author, forKey: "author")
        article.setValue(articleToSave.source, forKey: "source")
        article.setValue(articleToSave.url, forKey: "urlPath")
        article.setValue(articleToSave.isSaved, forKey: "isSaved")
        
        if let image = articleToSave.image {
            let jpegImage = image.jpegData(compressionQuality: 1.0)
            article.setValue(jpegImage, forKey: "icon")
        }
        
        do {
            try managedContext.save()
            print("CoreData saved")
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchArticlesFromCoreData() -> [ArticlesModel]? {
        
        guard let managedContext = managedContext else { return nil}
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Article")
        
        do {
            var articles =  [ArticlesModel]()
            
            let fetchedArticles = try managedContext.fetch(fetchRequest)
            
            for fetched in fetchedArticles {
                
                let newArticle = ArticlesModel(source: fetched.value(forKey: "source") as! String,
                                               author: fetched.value(forKey: "author") as! String,
                                               title: fetched.value(forKey: "title") as! String,
                                               description: fetched.value(forKey: "detailsInfo") as! String,
                                               url: fetched.value(forKey: "urlPath") as! String,
                                               image: UIImage(data: fetched.value(forKey: "icon") as! Data),
                                               publishedAt: fetched.value(forKey: "publishedAt") as! String,
                                               isSaved: fetched.value(forKey: "isSaved") as? Bool ?? false)
                articles.append(newArticle)
            }
            
            return articles
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
        
    }
    
    func deleteAllFromCoreData() {
        
        guard let managedContext = managedContext else { return}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        let deleteAllRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteAllRequest)
            print("CoreData cleared")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteEntityFromCoreData(title: String) {
        
        print("Start delete from CoreData")
        
        guard let managedContext = managedContext else { return}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        let pred = NSPredicate(format: "title=%@", title)
        
        fetchRequest.predicate = pred
        
        do {
            let articles = try managedContext.fetch(fetchRequest)
            if !articles.isEmpty,
               let objectDelete = articles[0] as? NSManagedObject {
                managedContext.delete(objectDelete)
            }
            
            try managedContext.save()
            print("CoreData saved")
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
