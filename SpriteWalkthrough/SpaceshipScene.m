//
//  SpaceshipScene.m
//  SpriteWalkthrough
//
//  Created by Ben Nied on 12/7/13.
//  Copyright (c) 2013 Ben Nied. All rights reserved.
//

#import "SpaceshipScene.h"
#include <stdlib.h>

@interface SpaceshipScene ()
@property BOOL contentCreated;
@end

@implementation SpaceshipScene

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    SKSpriteNode *spaceship = [self newSpaceship];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-150);
    [self addChild:spaceship];
    
    SKSpriteNode *spaceship2 = [self newSpaceship];
    spaceship2.position = CGPointMake(CGRectGetMidX(self.frame)/2, CGRectGetMidY(self.frame)-150);
    [self addChild:spaceship2];
    
    SKSpriteNode *spaceship3 = [self newSpaceship];
    spaceship3.position = CGPointMake(CGRectGetMidX(self.frame) + CGRectGetMidX(self.frame)/2, CGRectGetMidY(self.frame)-150);
    [self addChild:spaceship3];
    
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:0.05 withRange:0.05]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeRocks]];
}

- (SKSpriteNode *)newSpaceship
{
    SKSpriteNode *hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(128,32)];
    
    SKAction *hover = [SKAction sequence:@[
                                           [SKAction rotateToAngle:M_PI duration:0.5],
                                           [SKAction colorizeWithColor:[SKColor greenColor] colorBlendFactor:0 duration:0.5],
                                           [SKAction waitForDuration:5.0],
                                           [SKAction rotateToAngle:M_PI_2 duration:0.5],
                                           [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:0 duration:0.5],
                                           [SKAction waitForDuration:5.0],
                                           [SKAction rotateToAngle:M_PI_4 duration:0.5],
                                           [SKAction colorizeWithColor:[SKColor blueColor] colorBlendFactor:0 duration:0.5],
                                           [SKAction waitForDuration:5.0],
                                           [SKAction rotateToAngle:M_PI * 6 duration:0.5],
                                           [SKAction colorizeWithColor:[SKColor yellowColor] colorBlendFactor:0 duration:0.5],
                                           [SKAction waitForDuration:5.0],
                                           [SKAction rotateToAngle:M_PI * 8 duration:0.5],
                                           [SKAction colorizeWithColor:[SKColor grayColor] colorBlendFactor:0 duration:0.5],
                                           [SKAction waitForDuration:5.0]]];
    [hull runAction: [SKAction repeatActionForever:hover]];
    
    SKSpriteNode *light1 = [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    [hull addChild:light1];
    
    SKSpriteNode *light2 = [self newLight];
    light2.position = CGPointMake(28.0, 6.0);
    [hull addChild:light2];
    
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.dynamic = NO;
    hull.physicsBody.usesPreciseCollisionDetection = YES;
    hull.physicsBody.affectedByGravity = YES;
    
    
    return hull;
}

- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction: blinkForever];
    
    return light;
}

- (void)addRock
{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(8,8)];
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.affectedByGravity = YES;
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    rock.physicsBody.density = 1.0;
    rock.physicsBody.mass = 100.0;
    [self addChild:rock];
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}

@end
