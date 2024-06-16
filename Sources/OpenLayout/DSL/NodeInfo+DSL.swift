//
//  NodeInfo+DSL.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

extension View {
    func modifyNodeInfoValue<T: NodeInfoKey>(
        _ key: T.Type,
        _ modify: @escaping (inout T.Value) -> Void
    ) -> some View {
        ModifyNodeInfoValue(body: self, key: key, modify: modify)
    }
}

private struct ModifyNodeInfoValue<T: NodeInfoKey, Content: View>: View {
    let body: Content
    
    let key: T.Type
    let modify: (inout T.Value) -> Void
    
    func makeNode() -> Node {
        let node = self.body.makeNode()
        
        self.modify(&node.info[self.key])
        
        return node
    }
}
