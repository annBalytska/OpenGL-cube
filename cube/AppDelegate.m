//
//  AppDelegate.m
//  cube
//
//  Created by Anna Balytska on 5/28/13.
//  Copyright (c) 2013 softserve. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate()
@property (strong, nonatomic) GLKTextureInfo *texture;
@property (strong, nonatomic) GLKBaseEffect *effect;
@end

@implementation AppDelegate

GLfloat size = 0.8;

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:context];
    view.delegate = self;
    
    GLKViewController *controller = [[GLKViewController alloc] init];
    controller.delegate = self;
    controller.view = view;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    [self setupGL];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"cube" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cube.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)glkViewControllerUpdate:(GLKViewController *)controller {
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    GLKVector3 vertices[] = {
        GLKVector3Make(-0.5, -0.5,  0.5), // Left  bottom front
        GLKVector3Make( 0.5, -0.5,  0.5), // Right bottom front
        GLKVector3Make( 0.5,  0.5,  0.5), // Right top    front
        GLKVector3Make(-0.5,  0.5,  0.5), // Left  top    front
        GLKVector3Make(-0.5, -0.5, -0.5), // Left  bottom back
        GLKVector3Make( 0.5, -0.5, -0.5), // Right bottom back
        GLKVector3Make( 0.5,  0.5, -0.5), // Right top    back
        GLKVector3Make(-0.5,  0.5, -0.5), // Left  top    back
    };
    

    
    GLKVector3 triangleVertices[] = {
        // Front
        vertices[0], vertices[1], vertices[2],
        vertices[0], vertices[2], vertices[3],
        // Right
        vertices[1], vertices[5], vertices[6],
        vertices[1], vertices[6], vertices[2],
        // Back
        vertices[5], vertices[4], vertices[7],
        vertices[5], vertices[7], vertices[6],
        // Left
        vertices[4], vertices[0], vertices[3],
        vertices[4], vertices[3], vertices[7],
        // Top
        vertices[3], vertices[2], vertices[6],
        vertices[3], vertices[6], vertices[7],
        // Bottom
        vertices[4], vertices[5], vertices[1],
        vertices[4], vertices[1], vertices[0],
    };
    
    GLKVector3 normals[] = {
        GLKVector3Make(0, 0, 1), 
        GLKVector3Make(1, 0, 0),
        GLKVector3Make(0, 0, -1),
        GLKVector3Make(-1, 0, 1),
        GLKVector3Make(0, 1, 0),
        GLKVector3Make(0, -1, 0),
    };

    
    
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
 
    
    [_effect prepareToDraw];
    
    glEnable(GL_DEPTH_TEST);
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, triangleVertices);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, normals);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 3, GL_FLOAT, GL_FALSE,0, triangleVertices);

    glDrawArrays(GL_TRIANGLES, 0, 36);
    glDisableVertexAttribArray(GLKVertexAttribPosition);    
    glBindVertexArrayOES(0);
    
}



- (void)setupGL
{
    _effect = [[GLKBaseEffect alloc] init];
    
    GLKMatrix4 yRotation = GLKMatrix4MakeYRotation(1.0/8.0*2/M_PI);
    GLKMatrix4 xRotation = GLKMatrix4MakeXRotation(1.0/8.0*2/M_PI);
    GLKMatrix4 translate = GLKMatrix4MakeTranslation(0, 0, -1.8);
    
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(0.8f, 0.8f, 0.8f, 1.0f);
    self.effect.lightingType = GLKLightingTypePerVertex;
    
    _effect.transform.modelviewMatrix = GLKMatrix4Multiply(translate,GLKMatrix4Multiply(xRotation, yRotation));
    _effect.transform.projectionMatrix = GLKMatrix4MakePerspective(20.0, 0.75, 0.1, 100.0);
    
    
    glActiveTexture(GL_TEXTURE0);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tile_floor" ofType:@"png"];
    
    NSError *error = NULL;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                        forKey:GLKTextureLoaderOriginBottomLeft];
    
    
    _texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (_texture == nil)
        NSLog(@"Error loading texture: %@", [error localizedDescription]);
    
    
    GLKEffectPropertyTexture *tex = [[GLKEffectPropertyTexture alloc] init];
    tex.enabled = YES;
    tex.envMode = GLKTextureEnvModeDecal;
    tex.name = _texture.name;
    
    _effect.texture2d0.name = tex.name;
}



@end
