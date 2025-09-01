import matplotlib.pyplot as plt
import matplotlib.patches as patches
import networkx as nx

# ------------------------------
# Helper Functions for LinkedLists
# ------------------------------

def draw_node(ax, x, y, text, is_last=False, show_head=False):
    """Draw a node for the Single LinkedList diagram."""
    rect = patches.Rectangle((x, y), 1.5, 0.8, linewidth=1.5, edgecolor='black', facecolor='lightblue')
    ax.add_patch(rect)
    ax.text(x+0.75, y+0.4, text, ha='center', va='center', fontsize=10, weight='bold')
    
    # Arrow to next node
    if not is_last:
        ax.arrow(x+1.5, y+0.4, 0.7, 0, head_width=0.15, head_length=0.2, fc='black', ec='black')
    
    # Add Head arrow to the first node
    if show_head:
        ax.arrow(x-1, y+0.4, 0.5, 0, head_width=0.15, head_length=0.2, fc='red', ec='red')
        ax.text(x-1.2, y+0.4, "Head", ha='right', va='center', fontsize=10, color='red', weight='bold')

def draw_single_linkedlist(nodes, title):
    """Draw a full Single LinkedList diagram."""
    fig, ax = plt.subplots(figsize=(12, 2))
    for i, name in enumerate(nodes):
        draw_node(ax, i*2.5, 0, name, is_last=(i==len(nodes)-1), show_head=(i==0))
    ax.text(len(nodes)*2.5, 0.4, "NULL", ha='left', va='center', fontsize=10, weight='bold')
    ax.set_xlim(-2, len(nodes)*2.8)
    ax.set_ylim(-0.5, 1.5)
    ax.axis('off')
    ax.set_title(title, fontsize=12, weight='bold')
    plt.show()

def draw_doubly_linkedlist(nodes):
    """Draw a Doubly LinkedList diagram."""
    fig, ax = plt.subplots(figsize=(14, 2))

    for i, name in enumerate(nodes):
        # Draw node
        rect = patches.Rectangle((i*3, 0), 1.8, 0.8, linewidth=1.5, edgecolor='black', facecolor='lightgreen')
        ax.add_patch(rect)
        ax.text(i*3+0.9, 0.4, name, ha='center', va='center', fontsize=10, weight='bold')

        # Draw arrows (Prev and Next)
        if i > 0:
            ax.arrow(i*3, 0.4, -1.0, 0, head_width=0.15, head_length=0.2, fc='blue', ec='blue')
        if i < len(nodes)-1:
            ax.arrow(i*3+1.8, 0.4, 1.0, 0, head_width=0.15, head_length=0.2, fc='black', ec='black')
    
    # Add Head and NULL pointers
    ax.arrow(-1, 0.4, 0.5, 0, head_width=0.15, head_length=0.2, fc='red', ec='red')
    ax.text(-1.2, 0.4, "Head", ha='right', va='center', fontsize=10, color='red', weight='bold')
    ax.text(len(nodes)*3+0.2, 0.4, "NULL", ha='left', va='center', fontsize=10, weight='bold')
    ax.text(-1.0, -0.3, "NULL", ha='center', va='center', fontsize=10, weight='bold')

    ax.set_xlim(-2, len(nodes)*3.5)
    ax.set_ylim(-1, 1.5)
    ax.axis('off')
    ax.set_title("Doubly LinkedList", fontsize=12, weight='bold')
    plt.show()

# ------------------------------
# 1.1.4 C# Collection Framework Diagram
# ------------------------------

def draw_csharp_collections():
    """Draw the C# Collection Framework as a graph."""
    G = nx.DiGraph()

    # Root namespaces
    G.add_node("System.Collections")
    G.add_node("System.Collections.Generic")
    G.add_node("System.Collections.Concurrent")
    G.add_node("System.Collections.Specialized")

    # System.Collections
    G.add_edge("System.Collections", "ArrayList")
    G.add_edge("System.Collections", "Hashtable")
    G.add_edge("System.Collections", "Queue")
    G.add_edge("System.Collections", "Stack")

    # System.Collections.Generic
    G.add_edge("System.Collections.Generic", "List<T>")
    G.add_edge("System.Collections.Generic", "Dictionary<TKey, TValue>")
    G.add_edge("System.Collections.Generic", "Queue<T>")
    G.add_edge("System.Collections.Generic", "Stack<T>")
    G.add_edge("System.Collections.Generic", "LinkedList<T>")

    # System.Collections.Concurrent
    G.add_edge("System.Collections.Concurrent", "ConcurrentQueue<T>")
    G.add_edge("System.Collections.Concurrent", "ConcurrentStack<T>")
    G.add_edge("System.Collections.Concurrent", "ConcurrentDictionary<TKey, TValue>")

    # System.Collections.Specialized
    G.add_edge("System.Collections.Specialized", "NameValueCollection")
    G.add_edge("System.Collections.Specialized", "StringCollection")

    # Layout
    pos = nx.spring_layout(G, seed=42, k=1.5)

    # Draw the graph
    plt.figure(figsize=(14, 10))
    nx.draw(
        G, pos,
        with_labels=True,
        node_size=3500,
        node_color="lightyellow",
        font_size=9,
        font_weight="bold",
        arrows=True,
        edgecolors="black"
    )
    plt.title("C# Collection Framework", fontsize=14, weight="bold")
    plt.show()

# ------------------------------
# Run all diagrams
# ------------------------------

# 1.1.1 Original Single LinkedList
nodes_original = ["Dlamini", "Mtshali", "Ngcobo", "Mbuyazi", "Cele"]
draw_single_linkedlist(nodes_original, "1.1.1 Single LinkedList")

# 1.1.2 After inserting "Ndlovu" as 3rd element
nodes_inserted = ["Dlamini", "Mtshali", "Ndlovu", "Ngcobo", "Mbuyazi", "Cele"]
draw_single_linkedlist(nodes_inserted, "1.1.2 Single LinkedList (with 'Ndlovu')")

# 1.1.3 Doubly LinkedList
draw_doubly_linkedlist(nodes_original)

# 1.1.4 C# Collection Framework
draw_csharp_collections()
