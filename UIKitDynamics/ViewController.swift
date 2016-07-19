//
//  ViewController.swift
//  UIKitDynamics
//
//  Created by JHJG on 2016. 7. 18..
//  Copyright © 2016년 KangJungu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var blueBoxView:UIView?
    var redBoxView:UIView?
    var animator: UIDynamicAnimator?
    var currentLocation: CGPoint?
    var attachment:UIAttachmentBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frameRect = CGRectMake(10, 20, 80, 80)
        blueBoxView = UIView(frame: frameRect)
        blueBoxView?.backgroundColor = UIColor.blueColor()
        
        frameRect = CGRectMake(150, 20, 60, 60)
        redBoxView = UIView(frame: frameRect)
        redBoxView?.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(blueBoxView!)
        self.view.addSubview(redBoxView!)
        
        //다이내믹 애니메이터의 인스턴스를 생성, 초기화
        animator = UIDynamicAnimator(referenceView: self.view)
        
        //부모 뷰의 y축 방향 아래로 1.0 UIKit Newton의 중력이 적용될것이다.
        let gravity = UIGravityBehavior(items: [blueBoxView!, redBoxView!])
        let vector = CGVectorMake(0.0, 1.0)
        gravity.gravityDirection = vector
        
        //두개의 뷰가 서로 부딪힐 떄나 참조뷰의 경계에 다다랐을때 충돌이 발생한다.
        let collision = UICollisionBehavior(items: [blueBoxView!,redBoxView!])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        //파란색 상자 뷰의 탄성을 변경하여 빨간색 상자보다 더 높이 튕기도록 한다.
        let behavior = UIDynamicItemBehavior(items: [blueBoxView!])
        behavior.elasticity = 0.5
        
        //스프링 효과 주기
        let boxAttachment = UIAttachmentBehavior(item: blueBoxView!, attachedToItem: redBoxView!)
        //주기 값 설정
        boxAttachment.frequency = 4.0
        //감쇠 값 설정
        boxAttachment.damping = 0.0
        
        animator?.addBehavior(boxAttachment)
        animator?.addBehavior(behavior)
        animator?.addBehavior(collision)
        animator?.addBehavior(gravity)
    }
    
    //터치 시작할때
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let theTouch = touches.first{
            //터치한 좌표를 얻고
            currentLocation = theTouch.locationInView(self.view)
            //파란 상자 뷰가 앵커 포인트에 연결되어 있을때 오프셋 연결점에 따라 기울어진다.
            let offset = UIOffsetMake(20, 20)
            //그위치와 파란색 상자 뷰 사이의 연결동작을 애니메이터 인스턴스에 추가하도록 한다.
            attachment = UIAttachmentBehavior(item: blueBoxView!,
                                              offsetFromCenter: offset,
                                              attachedToAnchor: currentLocation!)
            animator?.addBehavior(attachment!)
        }
    }
    
    //터치움직일때
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let theTouch = touches.first{
            currentLocation = theTouch.locationInView(self.view)
            //연결 동작의 anchorPoint 속성이 이동을 따라가도록 한다.
            attachment?.anchorPoint = currentLocation!
        }
    }
    
    //터치가 끝난경우
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //연결은 제거 되고 이전의 정의된 중력 동작으로 인해 참조 뷰의 하단으로 떨어진다.
        animator?.removeBehavior(attachment!)
    }

}

