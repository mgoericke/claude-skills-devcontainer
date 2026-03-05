/**
 * REST-Controller für den Warenkorb.
 *
 * <p>BCE-Architektur: Boundary-Schicht (boundary/rest)
 *
 * @author Development Team
 * @author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via frontend-skill
 */
package de.javamark.boundary.rest;

import de.javamark.control.CartService;
import de.javamark.entity.Cart;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/cart")
@CrossOrigin
public class CartController {

    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Cart createCart() {
        return cartService.createCart();
    }

    @GetMapping("/{cartId}")
    public ResponseEntity<Cart> getCart(@PathVariable UUID cartId) {
        return cartService.findById(cartId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/{cartId}/items")
    public ResponseEntity<Cart> addItem(
            @PathVariable UUID cartId,
            @RequestBody Map<String, Object> body) {
        UUID productId = UUID.fromString((String) body.get("productId"));
        int quantity = body.containsKey("quantity") ? ((Number) body.get("quantity")).intValue() : 1;
        Cart cart = cartService.addItem(cartId, productId, quantity);
        return ResponseEntity.ok(cart);
    }

    @PutMapping("/{cartId}/items/{itemId}")
    public ResponseEntity<Cart> updateItem(
            @PathVariable UUID cartId,
            @PathVariable UUID itemId,
            @RequestBody Map<String, Integer> body) {
        int quantity = body.getOrDefault("quantity", 1);
        Cart cart = cartService.updateItemQuantity(cartId, itemId, quantity);
        return ResponseEntity.ok(cart);
    }

    @DeleteMapping("/{cartId}/items/{itemId}")
    public ResponseEntity<Cart> removeItem(
            @PathVariable UUID cartId,
            @PathVariable UUID itemId) {
        Cart cart = cartService.removeItem(cartId, itemId);
        return ResponseEntity.ok(cart);
    }

    @DeleteMapping("/{cartId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void clearCart(@PathVariable UUID cartId) {
        cartService.clearCart(cartId);
    }
}
